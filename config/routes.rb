Rails.application.routes.draw do

  root 'page#home'

  # Open pages
  get "/search", :to => "products#search"
  get "/products/:product_name", :to => "products#show_product"
  get "/shopping_cart", :to => "virtual_baskets#checkout"

  # Static pages
  get "/about_us", :to => "static_pages#about_us"
  get "/sell_with_us", :to => "static_pages#sell_with_us"
  get "/faqs", :to => "static_pages#faqs"
  get "/orders_and_shipping", :to => "static_pages#orders_and_shipping"
  get "/payment_and_pricing", :to => "static_pages#payment_and_pricing"
  get "/returns_and_refunds", :to => "static_pages#returns_and_refunds"
  get "/affiliate_programme", :to => "static_pages#affiliate_programme"
  get "/contact_us", :to => "static_pages#contact_us"
  get "/terms_and_conditions", :to => "static_pages#terms_and_conditions"
  get "/privacy_policy", :to => "static_pages#privacy_policy"
  get "/cookie_policy", :to => "static_pages#cookie_policy"

  #Collections test
  get "/collections", :to => "collections#show_all"
  get "/collections/:collection_name", :to => "collections#show"

  namespace :api do
    namespace :v1 do
      get "/virtual_baskets/add_product", :to => "virtual_baskets#add_product", defaults: { format: 'json' }
      get "/virtual_baskets/remove_product", :to => "virtual_baskets#remove_product", defaults: { format: 'json' }
      get "/products/search", :to => "products#get_products_api", defaults: { format: 'json' }
      get "/products/suggestions", :to => "products#get_products_suggestions", defaults: { format: 'json' }
      post "/set_geolocation", :to => "application#set_geolocation", defaults: { format: 'json' }
      post "/submissions/submit_seller_info", :to => "submissions#submit_seller_info", defaults: { format: 'json' }
    end
  end

  authenticate :user do
    get '/order/new', to: redirect('/order/new/delivery_details')
    get "/order/new/delivery_details",  :to => "orders#new"
    get "/order/:order_id/payment", :to => "orders#pay"
    get "/order/:order_id/show", :to => "orders#show"

    scope "/users" do
      get "/my_orders", :to => "users/users#show_orders"
    end

    namespace :api do
      namespace :v1 do
        post "/order/create", :to => "orders#create", defaults: { format: 'json' }
        post "/order/verify_stripe_payment", :to => "orders#verify_stripe_payment", defaults: { format: 'json' }
        post "/promocode/check_code", :to => "promocodes#check_code", defaults: { format: 'json' }

        get "/get_comments", :to => "comments#get", defaults: {format: 'json'}
        post "/add_comment", :to => "comments#add", defaults: {format: 'json'}
      end
    end
  end

  authenticate :shop do
    scope "/shops" do
      get "/registration_pending", :to => "shops/shop#registration_pending"
      get "/complete_registration", :to => "shops/shop#complete_registration"
      get "/my_shop", :to => "shops/shop#show_products"
      get "/my_shop/details", :to => "shops/shop#details"
      get "/my_shop/products", :to => "shops/shop#show_products"
      get "/my_shop/products/new", :to => "shops/shop#new_product"
      get "/my_shop/products/edit/:product_id", :to => "shops/shop#edit_product"
      get "/my_shop/orders", :to => "shops/shop#show_orders"
      get "/my_shop/orders", :to => "shops/shop#orders"
      get "/my_shop/opening_date_and_times", :to => "shops/shop#opening_date_and_times"
      get "/my_shop/orders/:order_id", :to => "shops/shop#order_details"
    end

    namespace :api do
      namespace :v1 do
        # shop details APIs
        post "/update_shop_info", :to => "shops#update_shop_info", defaults: { format: 'json' }
        post "/update_shop_avatar", :to => "shops#update_shop_avatar", defaults: { format: 'json' }

        # shop products APIs
        post "/create_product/", :to => "products#create_product", defaults: { format: 'json' }
        post "/delete_product/:id", :to => "products#delete_product", defaults: { format: 'json' }
        post "/update_product/:id", :to => "products#update_product", defaults: { format: 'json' }

        # shop opening hours API
        post "opening_hours", :to => "opening_hours#update_week_opening_hours", defaults: { format: 'json' }
      end
    end
  end

  # Devise routes
  devise_for :shops, controllers: {
    registrations: "shops/registrations",
    sessions: "shops/sessions",
    passwords: "shops/passwords",
    confirmations: "shops/confirmations"
  }

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords",
    confirmations: "users/confirmations"
  }
  
  devise_scope :user do
    post "/users/sign_in", :to => "users/sessions#create"
    get "/users/sign_out", :to => "users/sessions#destroy"
    post "/users/password", to: "users/passwords#create"
    get "/users/password/new", to: "users/passwords#new"
    get "/users/edit", :to => "users/registrations#edit"
  end

  devise_scope :shop do
    post "/shops/sign_in", :to => "shops/sessions#create"
    get "/shops/sign_out", :to => "shops/sessions#destroy"
    post "/shops/password", to: "shops/passwords#create"
    get "/shops/password/new", to: "shops/passwords#new"
    get "/shops/edit", :to => "shops/registrations#edit"
  end


  # Routes to manage webhooks with stripe
  # https://stripe.com/docs/webhooks
  namespace :stripe do
    namespace :webhooks do
      post '/webhook_handler', :to => "webhooks#handler"
    end
  end

end