class Admin::MerchantsController < ApplicationController
  before_action :require_admin

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    if merchant.enabled == true
      merchant.disable
      flash[:notice] = "This merchant\'s account is now disabled."
    else
      merchant.enable
      flash[:notice] = "This merchant\'s account is now enabled."
    end
    redirect_to "/admin/merchants"
  end
end
