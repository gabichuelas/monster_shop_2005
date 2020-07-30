class Merchant::ItemOrdersController < ApplicationController
  before_action :require_merchant

  def update
    item_order = ItemOrder.find(params[:id])
    order = Order.find(item_order.order_id)
    item_order.update(status: "fulfilled")
    item_order.item.update!(inventory: item_order.item.inventory - item_order.quantity)
    flash[:success] = "This order has been fulfilled"
    redirect_to "/merchant/orders/#{item_order.order.id}"
    if order.item_orders.all? { |item_order| item_order.status == "fulfilled" }
      order.update(status: "packaged")
    end
  end
end
