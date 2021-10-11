module ErrorHandling
  def respond_with_error(error, invalid_resource = nil, error_messages = nil)
    error = API_ERRORS[error]
    if invalid_resource.present? && error['details'].blank?
      error['details'] = (invalid_resource.errors.full_messages rescue "resource doesn't have error messages")
    elsif error_messages.present?
      error['details'] = error_messages
    end
  
    respond_to do |format|
      format.json { render json: {error: error}.to_json }
    end
  end
end