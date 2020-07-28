class Merchant::ItemsController < ApplicationController
  before_action :require_merchant

  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items
    else
      @items = Item.all
    end
  end

  def new
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def create
    @merchant = Merchant.find(current_user.merchant_id)
    item = @merchant.items.create(item_params)
    if item.save
      redirect_to "/merchant/items"
    else
      flash[:error] = item.errors.full_messages.to_sentence
      render :new
    end
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

  private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end
end
