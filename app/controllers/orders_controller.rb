class OrdersController <ApplicationController

  def index
    @orders = current_user.orders
  end

  def new

  end

  def show
    @order = Order.find(params[:id])
    if @order.item_orders.all? { |item_order|  item_order.status == "fulfilled" }
      @order.update(status: "packaged")
    end
  end

  def create
    order = current_user.orders.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      flash[:notice] = "Your order has been created."
      session.delete(:cart)
      redirect_to "/profile/orders"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def destroy
    order = Order.find(params[:id])
    order.update(status: 3)
    # write model test for the following:
    order.cancel_items
    order.restock
    flash[:success] = 'Your order is now cancelled'
    redirect_to "/profile/orders"
  end

  def index

  end


  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
