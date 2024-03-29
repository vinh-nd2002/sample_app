class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def show
    @page, @microposts = pagy @user.microposts,
                              items: Settings.microposts.item_per_page
  end

  def index
    @pagy, @users = pagy(User.all, items: Settings.users.item_per_page)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "activation.message"
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "users.update.success"
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.delete.success"
    else
      flash[:danger] = t "users.delete.failed"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t "users.update.can_not"
    redirect_to root_path
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t "users.update.can_not"
    redirect_to root_path
  end
end
