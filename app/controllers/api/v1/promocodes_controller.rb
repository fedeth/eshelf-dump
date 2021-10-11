class Api::V1::PromocodesController < ApplicationController
  include PromocodesHelper

  def check_code
    errors = []
    if check_promocode_validity(promocode_params[:promocode].downcase.strip, errors)
      promocode = Promocode.find_by_name(promocode_params[:promocode].downcase.strip)
    end

    response = {success: errors.blank?, errors: errors}
    response[:value] = promocode.value if response[:success]
    respond_to do |format|
      format.json { render json: response }
    end
  end

  private

    def promocode_params
      params.permit(:promocode, :format)
    end
  

end