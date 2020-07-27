class Admin::OrdersController < ApplicationController
  def update
    @order = Order.find(params[:id])
    @order.update(status: params[:status].to_i)
    redirect_to '/admin'
  end
end
