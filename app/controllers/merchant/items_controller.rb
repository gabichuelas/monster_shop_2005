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
    @item = Item.find(params[:id])
    @item.update(item_params)
    if @item.save
      flash[:notice] = "#{@item.name} has been updated"
      redirect_to '/merchant/items'
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def update_status
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

  private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end
end
