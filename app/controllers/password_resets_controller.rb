class PasswordResetsController < ApplicationController
  # request password reset.
  # you get here when the user entered his email in the reset password form and submitted it.
  def create
    @user = User.find_by_email(params[:email])
    @user.becomes(User) if @user
    @user.deliver_reset_password_instructions! if @user
    redirect_to(root_path, :notice => 'Instructions have been sent to your email.')
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])
    @user.becomes(User) if @user
    if @user.blank?
      not_authenticated
      return
    end
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])
    @user.becomes(User) if @user
    if @user.blank?
      not_authenticated
      return
    end

    @user.password_confirmation = params[:member][:password_confirmation]
    if @user.change_password!(params[:member][:password])
      redirect_to(root_path, :notice => 'Password was successfully updated.')
    else
      render :action => "edit"
    end
  end
end
