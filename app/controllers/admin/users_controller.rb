class Admin::UsersController < ApplicationController
  before_action :require_admin

  def index
    @users = User.all
    render file: "/public/404" unless current_admin?
  end

  def show
    @user = User.find(params[:user_id])
  end
end
