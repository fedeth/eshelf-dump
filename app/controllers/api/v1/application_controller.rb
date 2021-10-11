class Api::V1::ApplicationController < ApplicationController
  include ErrorHandling
  include PostcodesHelper

  def set_geolocation
    # TODO: set cookies properly

    if params[:postcode].present?
      begin
        postcode = Postcode.where(postcode: get_possible_postcodes(params[:postcode])).first
        if postcode.present?
          cookies.signed[:postcode] = postcode.postcode
          if current_user.present?
            current_user.postcode = postcode.postcode
            current_user.save
          end
          respond_to do |format|
            format.json { render json: {status: :ok, postcode: postcode.postcode} }
          end
        else
          raise ActiveRecord::RecordNotFound
        end
      rescue ActiveRecord::RecordNotFound => error
        respond_with_error('postcode_not_found')
      end
    elsif params[:coords].present?
      coords = JSON.parse(params[:coords])
      latitude = coords['latitude'].to_f
      longitude = coords['longitude'].to_f
      max_latitude = Postcode.maximum(:latitude)
      min_latitude = Postcode.minimum(:latitude)
      max_longitude = Postcode.maximum(:longitude)
      min_longitude = Postcode.minimum(:longitude)

      if (latitude > max_latitude || latitude < min_latitude || longitude > max_longitude || longitude < min_longitude)
        respond_with_error('unavailable_location')
      else
        postcode = Postcode.where(latitude: min_latitude..latitude, longitude: min_longitude..longitude).order(latitude: :desc, longitude: :desc).limit(1).first;
        cookies.signed[:postcode] = postcode.postcode
        if current_user.present?
          current_user.postcode = postcode.postcode
          current_user.save
        end
        cookies.signed[:coords] = params[:coords]
        respond_to do |format|
          format.json { render json: {status: :ok, postcode: postcode.postcode, coords: params[:coords]} }
        end
      end
    else
      respond_with_error('no_postcode_provided')
    end
  end

end