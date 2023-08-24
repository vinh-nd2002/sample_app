class AccountActivationsController < ApplicationController
  before_action :find_user, only: :edit

  def edit
    user = @user
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t "activation.success"
      redirect_to user
    else
      flash[:danger] = t "activation.failed"
      redirect_to root_url
    end
  end

  def find_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "users.not_found"
    redirect_to root_path
  end
end
