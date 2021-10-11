module SubmissionsHelper
  def validate_form_seller_join_us(form_data)
    errors = []
    if form_data["firstName"].blank?
      errors.push("first name can't be blank")
    end
    if form_data["lastName"].blank?
      errors.push("last name can't be blank")
    end
    if form_data["companyName"].blank?
      errors.push("company name can't be blank")
    end
    if form_data["emailAddress"].blank?
      errors.push("email address can't be blank")
    end
    if form_data["phoneNumber"].blank?
      errors.push("phone number  can't be blank")
    end

   errors

  end
end
