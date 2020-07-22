class Admin::UsersController < Admin::BaseController

  def show
    @user = User.find(session[:user_id])
  end
end
