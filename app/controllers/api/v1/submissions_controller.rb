class Api::V1::SubmissionsController < ApplicationController
  include ErrorHandling
  include SubmissionsHelper
  include RecaptchaV3Helper

  def form_params
    params.permit(
      :firstName, :lastName,:companyName, :companyName, :emailAddress,
      :phoneNumber, :socialMediaUrl, :websiteUrl, :recaptcha_v3_token, :format
    )
  end

  def submit_seller_info
    errors = []

    if Submission.where("created_at > ?", DateTime.now - 12.hour).count > 15
      # Flooding errors must take priority over validations and recaptcha errors
      errors.push("Flooding detected, please retry submission in a few hours")
    end

    if recaptcha_v3_required? && errors.blank?
      recaptcha_response = validate_recaptcha_v3()
      if recaptcha_response[:errors].present?
        # Recaptcha must take priority over validation's errors
        errors.push(recaptcha_response[:errors][:messages])
      end
    end
    
    if errors.blank?
      validation_errors = validate_form_seller_join_us(form_params)
      if validation_errors.present?
        errors.push(validation_errors)
      end
    end

    errors.flatten!

    if errors.blank?
      Submission.create(
        form_fields: form_params.except("recaptcha_v3_token", "format"),
        email: form_params["emailAddress"],
        user_id: nil,
        label: "seller_join_us"
      )
      ApplicationMailer.mail_seller_join_us(form_params).deliver_later
    end
   
    respond_to do |format|
      format.json { render json: {success: errors.blank? , errors: errors} }
    end
  end

  def submit_form
    submission = nil
    form_data = params.except(:email, :label)
    user_id = current_user.present? ? current_user.id : nil
    email = params[:email] || (current_user.email if current_user.present?)

    if !email.present?
      respond_with_error('email_required')
    end

    begin
      submission = Submission.create(form_fields: form_data.to_json, email: email, user_id: user_id, label: params[:label])
      if submission.errors.any?
        respond_with_error('invalid_resource', submission)
      end
    rescue => e
      respond_with_error('server_error', e)
    end

    respond_to do |format|
      format.json { render json: {status: :ok, submission: submission} }
    end
  end

end