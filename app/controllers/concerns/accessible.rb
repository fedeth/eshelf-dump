module Accessible extend ActiveSupport::Concern

  included do
    before_action :check_user
  end

  protected
  def check_user
    if current_shop
      flash.clear 
      # if you have rails_admin. You can redirect anywhere really
      redirect_to root_path and return
    elsif current_user
      flash.clear
      redirect_to (stored_location_for(:user) || root_path) and return
    end
  end
end