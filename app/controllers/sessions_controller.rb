class SessionsController < ApplicationController
  def new
    if current_merchant?
      redirect_to '/merchant'
      flash[:success] = "You are already logged in!"
    elsif current_admin?
      redirect_to '/admin'
      flash[:success] = "You are already logged in!"
    elsif current_user
      redirect_to '/profile'
      flash[:success] = "You are already logged in!"
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}! You are now logged in."
      if current_admin?
        redirect_to '/admin'
      elsif current_merchant?
        redirect_to '/merchant'
      elsif current_user
        redirect_to '/profile'
      end 
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:cart)
    flash[:success] = "You have logged out."
    redirect_to "/"
  end
end
