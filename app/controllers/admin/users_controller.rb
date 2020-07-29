class Admin::UsersController < ApplicationController
  before_action :require_admin

  def show
    @user = User.find(params[:user_id])
  end
end
