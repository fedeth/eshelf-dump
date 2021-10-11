module RecaptchaV3Helper
  # Error codes reference:
  #
  # missing-input-secret:  The secret parameter is missing.
  # invalid-input-secret:  The secret parameter is invalid or malformed.
  # missing-input-response:  The response parameter is missing.
  # invalid-input-response:  The response parameter is invalid or malformed.
  # bad-request The request: is invalid or malformed.
  # timeout-or-duplicate:  The response is no longer valid: either is too old or has been used previously.
  RECAPTCHA_URL = "https://www.google.com/recaptcha/api/siteverify".freeze

  def get_recaptcha_v3_script
    if recaptcha_v3_required?
      "<script src=\"https:\/\/www.google.com\/recaptcha\/api.js?render=#{get_recaptcha_v3_site_key}\"><\/script>".html_safe
    end
  end

  def recaptcha_v3_required?
    get_recaptcha_v3_secret_key.present? && get_recaptcha_v3_site_key.present?
  end

  def get_recaptcha_v3_secret_key
    ENV['G_RECAPTCHA_SECRET_KEY']
  end

  def get_recaptcha_v3_site_key
    ENV['G_RECAPTCHA_SITE_KEY']
  end

  def validate_recaptcha_v3(threshold = 0.8)
    response = {:success => false, :errors => {}}
    if get_recaptcha_v3_secret_key.present?
      token = params.require(:recaptcha_v3_token) rescue nil
      headers = { "Content-Type" => "application/json" }
      body_params = {:secret => get_recaptcha_v3_secret_key, :response => token, :remoteip => request.remote_ip}
      result = JSON.parse(HTTParty.post(RECAPTCHA_URL, headers: headers, query: body_params).body)
      
      if result["success"]
        if result["score"] >= threshold
          response[:success] = true
        else
          response[:errors][:messages] ||= []
          response[:errors][:messages].push("Treshold error")
          response[:errors][:info] = { expected_threshold: threshold, returned_value: result["score"].to_f }
        end
      else
        response[:errors][:messages] ||= []
        if result["error-codes"].present?
          result["error-codes"].each do |err_code|
            response[:errors][:messages].push("Error: #{err_code}")
          end
        else
          response[:errors][:messages].push("Error: unknown_error")
        end
      end
    else
      response[:errors][:messages] ||= []
      response[:errors][:messages].push("Configuration error: missing_keys?")
    end
    response
  end

  def recaptcha_v3_sign_up_error_handler(recaptcha_errors, sign_up_params)
    self.resource = resource_class.new sign_up_params
    resource.validate
    errors_msg = []
    recaptcha_errors[:messages].each do |r_err|
      resource.errors.add(:base, r_err)
      errors_msg.push(r_err)
    end
    # log_info("google recaptcha error", {message: errors_msg, info: recaptcha_errors[:info]})
    respond_with_navigational(resource) { render :new }
  end

end