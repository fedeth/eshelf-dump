module EshelfUtils
  def eshelf_before_action
    if ENV['CREDENTIAL_USERNAME'].present? && ENV['CREDENTIAL_PASSWORD'].present?
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV['CREDENTIAL_USERNAME'] && password == ENV['CREDENTIAL_PASSWORD']
      end
    end

    if ENV['FORCE_WWW'].present? && !ENV['FORCE_NO_WWW'].present? && !/^www/.match(request.host)
      redirect_to("#{request.url}".gsub("#{request.protocol}", "#{request.protocol}www."), status: 301)
    end

    if ENV['FORCE_NO_WWW'].present? && !ENV['FORCE_WWW'].present? && /^www/.match(request.host)
      redirect_to("#{request.url}".gsub("#{request.protocol}www.", "#{request.protocol}"), status: 301)
    end
    
  end
end