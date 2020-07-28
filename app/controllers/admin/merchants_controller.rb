class Admin::MerchantsController < ApplicationController
  def show
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    if merchant.enabled == true
      merchant.update(enabled: !merchant.enabled)
      flash[:notice] = "This merchant\'s account is now disabled."
    else
      merchant.update(enabled: merchant.enabled) #<---- this may be wrong?
      flash[:notice] = "This merchant\'s account is now enabled."
    end
    redirect_to "/merchants"
  end
end
