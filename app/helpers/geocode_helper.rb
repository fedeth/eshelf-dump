module GeocodeHelper

  # returns something like {"latitude": Float, "longitude": Float}
  def current_user_location
    postcode = cookies.signed[:postcode].present? ? cookies.signed[:postcode] : nil
    postcode = postcode.present? ? postcode : (current_user.postcode rescue nil)
    coords = cookies.signed[:coords].present? ? JSON.parse(cookies.signed[:coords]) : nil
    postcode_record = postcode.present? ? Postcode.find(postcode) : nil
    location = postcode_record.present? ? postcode_record.as_json : coords.present? ? coords : nil
    if location.present?
      {
        "latitude" => location["latitude"].to_f,
        "longitude" => location["longitude"].to_f
      }
    else
      nil
    end
  end

  def build_geolocation_info
    geolocation_info = {}
    if cookies.signed[:postcode].present?
      geolocation_info[:postcode] = cookies.signed[:postcode]
    elsif current_user.present? && current_user.postcode.present?
      geolocation_info[:postcode] = current_user.postcode
    end
    if cookies.signed[:coords].present?
      geolocation_info[:coords] = JSON.parse(cookies.signed[:coords])
    end

    geolocation_info

  end

end