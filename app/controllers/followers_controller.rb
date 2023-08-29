class FollowersController < ApplicationController
  before_action :logged_in_user, :find_user

  def index
    @title = t "relationships.follower"
    @pagy, @users = pagy @user.followers, items: Settings.users.item_per_page
    render "users/show_follow"
  end
end
