class UsersController <ApplicationController

  def new
  end

  def show
    @user = User.find(session[:user_id])
  end

  def create
    new_user = User.new(user_params)
    if new_user.save
      flash[:success] = "You are now registered and logged in"
      session[:user_id] = new_user.id
      redirect_to "/profile"
    else
      flash[:errors] = new_user.errors.full_messages.to_sentence
      redirect_to "/register"
    end
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end
end
