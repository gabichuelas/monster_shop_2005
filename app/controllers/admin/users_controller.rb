class Admin::UsersController < Admin::BaseController
  def index
    # this is populated by default html in applications.html.erb
  end

  def show
    @user = User.find(session[:user_id])
  end
end
