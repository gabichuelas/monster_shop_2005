class Merchant::ItemOrdersController < ApplicationController
  before_action :require_merchant
  
  def update
    item_order = ItemOrder.find(params[:id])
    item_order.toggle!(:status)
    item_order.item.update!(inventory: item_order.item.inventory - item_order.quantity)
    flash[:success] = "This order has been fulfilled"
    redirect_to "/merchant/orders/#{item_order.order.id}"
  end
end
