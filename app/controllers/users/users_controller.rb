class Users::UsersController < PageController

  include OrdersHelper

  def products_search
  end

  def show_orders
    @content = {}
    orders = Order.where(user_id: current_user.id).eager_load(:payment).order(created_at: :desc)
    @content[:orders] = build_orders(orders)
    @content
  end

end