class Merchant::ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items
    else
      @items = Item.all
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    item = Item.find(params[:id])
    if item.active?
      item.update(active?: false)
      flash[:notice] = "This item is now inactive"
    else
      item.update(active?: true)
      flash[:notice] = "This item is now active"
    end
    redirect_to '/merchant/items'
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    flash[:notice] = "#{item.name} has been deleted"
    redirect_to '/merchant/items'
  end
end
