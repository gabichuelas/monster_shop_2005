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
      if current_admin?
        flash[:success] = "Welcome, #{user.name}! You are now logged in."
        redirect_to '/admin'
      elsif current_merchant?
        flash[:success] = "Welcome, #{user.name}! You are now logged in."
        redirect_to '/merchant'
      elsif current_user
        flash[:success] = "Welcome, #{user.name}! You are now logged in."
        redirect_to '/profile'
      end
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :new
    end
  end
end
