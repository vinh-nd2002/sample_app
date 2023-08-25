class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def edit; end

  def update
    if user_params[:password].empty?
      @user.errors.add(:password, t("forgot_password.password_empty"))
      render :edit, status: :unprocessable_entity
    elsif @user.update user_params
      reset_session
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t "forgot_password.success"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @user = User.find_by email: params.dig(:password_reset, :email)&.downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "forgot_password.info"
      redirect_to root_url
    else
      flash.now[:danger] = t "forgot_password.not_found"
      render :new, status: :unprocessable_entity
    end
  end

  private
  def get_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "forgot_password.not_found"
    redirect_to root_url
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "forgot_password.not_active"
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "forgot_password.expired"
    redirect_to new_password_reset_url
  end
end
