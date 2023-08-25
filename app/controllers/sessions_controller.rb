class SessionsController < ApplicationController
  def new; end

  def create
    user = find_user_by_email
    if user_authenticated?(user)
      user_activated user
    else
      handle_failed_login
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

  private

  def find_user_by_email
    @user = User.find_by email: params.dig(:session, :email)&.downcase
  end

  def user_authenticated? user
    user&.authenticate(params[:session][:password])
  end

  def user_activated user
    if user.activated
      handle_successful_login user
    else
      flash[:warning] = t "activation.message"
      redirect_to root_path
    end
  end

  def handle_successful_login user
    following_url = session[:following_url]
    reset_session
    remember_or_forget user
    log_in user
    session[:following_url] = following_url
    redirect_back_or user
  end

  def remember_or_forget user
    if params[:session][:remember_me] == "1"
      remember(user)
    else
      forget(user)
    end
  end

  def handle_failed_login
    flash.now[:danger] = t("login.danger_flash")
    render :new, status: :unprocessable_entity
  end
end
