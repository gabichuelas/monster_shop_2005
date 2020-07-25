class UsersController <ApplicationController

  def new
    # displays registration form
  end

  def show
    render file: "/public/404" unless current_user
  end

  def edit
    render file: "/public/404" unless current_user
  end

  def update
    current_user.update(user_edit_params)
    if current_user.save
      redirect_to "/profile"
    else
      flash[:errors] = current_user.errors.full_messages
      redirect_to "/users/edit"
    end
  end

  def create
    @new_user = User.new(user_params)
    if @new_user.save
      flash[:success] = "You are now registered and logged in"
      session[:user_id] = @new_user.id
      redirect_to "/profile"
    else
      flash[:errors] = @new_user.errors.full_messages
      render :new
    end
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end

  def user_edit_params
    params.permit(:name, :address, :city, :state, :zip, :email)
  end
end
