module EventsLogUtils

  def init_global_variables(env)
    $http_host = (env["HTTP_HOST"]).split(":").first,
    $http_uri = env["HTTP_HOST"],
    $request_uri = env["REQUEST_URI"].dup,
    $method = env["REQUEST_METHOD"],
    $http_referer = env["HTTP_REFERER"],
    $user_agent = env["HTTP_USER_AGENT"],
    $app_server = Socket.gethostname,
    $session_id = env["rack.session"]["session_id"],
    $remote_ip = env["action_dispatch.remote_ip"].to_s,
    $user_id = (env["rack.session"]["warden.user.user.key"][0][0] rescue -1),
    $shop_id = (env["rack.session"]["warden.user.shop.key"][0][0] rescue -1),
    $pid = Process.pid
  end

  def log_data
    {
      http_host: $http_host,
      request_uri: $request_uri,
      method: $method,
      http_referer: $http_referer,
      user_agent: $user_agent,
      app_server: $app_server,
      session_id: $session_id,
      remote_ip: $remote_ip,
      user_id: $user_id,
      shop_id: $shop_id,
      pid: $pid
    }
  end

  def log_event(data, label, level, synced = false)
    new_data = log_data.merge(data)
    new_data[:level] = level
    new_data[:label] = label
    new_data[:timestamp] = Time.now
    if synced
      log_event_to_db new_data true
    else
      log_event_to_file new_data
    end
  end

  def log_exception(exception, data = {}, label = nil, synced = false)
    new_data = data.empty? ? log_data : log_data.merge(data)
    new_data[:level] = :error
    new_data[:label] = label || "exception"
    new_data[:timestamp] = Time.now
    new_data[:exception] = exception.to_s
    new_data[:backtrace] = exception.backtrace[0, 5]
    new_data[:status] = get_status_code_from_exception(exception)
    log_event_to_file new_data
  end

  def get_status_code_from_exception(exception)
    exception_wrapper = ActionDispatch::ExceptionWrapper.new(nil, exception)
    exception_wrapper.status_code
  rescue
    500
  end

  def log_event_to_db(data, synced)
    additional_data = data.except(:session_id, :pid, :request_uri, :timestamp, :level, :user_id, :label)
    new_log = LogEvent.new(
      session_id: data[:session_id],
      pid: data[:pid],
      request_uri: data[:request_uri],
      timestamp: data[:timestamp],
      level: data[:level],
      user_id: data[:user_id],
      data: additional_data.to_json,
      synced: synced,
      label: data[:label] || "undefined"
    )
    new_log.save
    new_log
  end

  def log_event_to_file(data)
    try = 0;
    success = false;
    while try < 3 && !success
      begin
        File.open("#{Rails.root}/log/events/#{data[:pid]}_#{data[:session_id]}_#{Time.now.to_i}.json", File::CREAT|File::WRONLY|File::EXCL) do |f|
          f.write(data.to_json)
          success = true
        end
      rescue Errno::EEXIST => e
        sleep 0.005
        if try < 3
          try = try + 1
        else
          raise e
        end
      end
    end
  end
end