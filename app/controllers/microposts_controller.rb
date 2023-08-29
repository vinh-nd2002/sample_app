class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params.dig(:micropost, :image)
    if @micropost.save
      handle_successful_creation
    else
      handle_failed_creation
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "microposts.delete.success"
    else
      flash[:danger] = t "microposts.delete.failed"
    end
    redirect_to root_url
  end

  private
  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]

    return if @micropost

    flash[:danger] = t "microposts.error"
    redirect_to root_url
  end

  def handle_successful_creation
    flash[:success] = t("microposts.create.success")
    redirect_to root_url
  end

  def handle_failed_creation
    @pagy, @feed_items = pagy current_user.feed,
                              items: Settings.microposts.item_per_page
    flash[:danger] = t("microposts.create.failed")
    render "static_pages/home", status: :unprocessable_entity
  end
end
