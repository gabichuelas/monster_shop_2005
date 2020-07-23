class PasswordsController < ApplicationController
  before_action :current_user

  def edit
  end

  def update
    current_user.update(pass_params)
    if current_user.authenticate(params[:password_confirmation])
      redirect_to "/profile"
      flash[:success] = 'Your password has been updated.'
    else
      flash[:errors] = current_user.errors.full_messages
      redirect_to "/passwords/edit"
    end
  end

  private

  def pass_params
    params.permit(:password, :password_confirmation)
  end
end
