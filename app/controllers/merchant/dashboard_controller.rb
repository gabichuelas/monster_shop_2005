class Merchant::DashboardController < ApplicationController
  before_action :require_merchant

  def index
  end

  # def show  <----- made this when I did the routes wrong. Hoping this will work when the routes are corrected. 
  #   if current_user.merchant_id != nil
  #   @merchant = Merchant.find(current_user.merchant_id)
  # end
end
