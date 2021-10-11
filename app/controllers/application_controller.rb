class ApplicationController < ActionController::Base

  include ApplicationHelper
  include CategoriesHelper
  include GeocodeHelper
  include VirtualBasketsHelper
  include EshelfUtils
  include RecaptchaV3Helper

  before_action :eshelf_before_action
  before_action :build_page_model
  before_action :store_user_location!, if: :storable_location?

  def build_page_model
    @page_model = {
      :path => request.path,
      :cart_info => build_cart_info(),
      :user_info => build_user_info(),
      :shop_info => build_shop_info(),
      #:geolocation_info => build_geolocation_info(),
      :categories => build_categories(), # TODO: cache this value.
      :search_params => {
        page: nil,
        searchText: nil,
        order: "",
        categoryFilters: [],
        price: [0, 1000]
      },
      :search_results => {},
      :recaptcha_v3 => {},
      :rails_flash_messages => {
        notice: flash.notice.dup,
        alert: flash.alert.dup
      },
      :constants => {
        "STANDARD_SHIPPING_COST": STANDARD_SHIPPING_COST
      }
    }

    if recaptcha_v3_required?
      @page_model[:recaptcha_v3] = {site_key: get_recaptcha_v3_site_key()}
    end

    @page_model
  end
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  rescue
    render_404
  end

  def render_404
    render file: Rails.root.join('public/404.html'), status: :not_found
  end

  private
    # Its important that the location is NOT stored if:
    # - The request method is not GET (non idempotent)
    # - The request is handled by a Devise controller such as Devise::SessionsController as that could cause an 
    #    infinite redirect loop.
    # - The request is an Ajax request as this can lead to very unexpected behaviour.
    def storable_location?
      request.get? && is_navigational_format? && !devise_controller? && !request.xhr? 
    end

    def store_user_location!
      store_location_for(:user, request.fullpath)
    end

end

