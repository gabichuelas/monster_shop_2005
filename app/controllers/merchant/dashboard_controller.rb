class Merchant::DashboardController < ApplicationController
  before_action :require_merchant

  def index
  end

  def show
    @merchant = Merchant.find(current_user.merchant_id)
  end
end
