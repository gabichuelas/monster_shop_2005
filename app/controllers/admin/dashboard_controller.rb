class Admin::DashboardController < ApplicationController
  before_action :require_admin

  def index
    # this is populated by default html in applications.html.erb
  end
end
