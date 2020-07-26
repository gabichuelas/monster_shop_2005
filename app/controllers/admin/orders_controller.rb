class Admin::OrdersController < ApplicationController
  def ship
    order = Order.find(params[:id])
    order.update(status: 'shipped')
    redirect_to '/admin'
  end
end
