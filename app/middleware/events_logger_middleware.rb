class EventsLoggerMiddleware
  include EventsLogUtils

  def initialize(app)
    @app = app
  end

  def call(env)
    init_global_variables env
    start = Time.now
    # log_event({}, 'http request start', :debug)
    begin
      @status, @headers, @response = @app.call(env)
      data = {
        status: @status,
        time: Time.now - start
      }
      log_event(data, 'http request end', :debug)
    rescue Exception => ex
      log_exception(ex, {time: Time.now - start})
      raise ex
    end
    [@status, @headers, @response]
  end
end