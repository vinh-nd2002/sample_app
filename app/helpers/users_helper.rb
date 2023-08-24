module UsersHelper
  def gravatar_for user, options = {size: Settings.users.avatar_size}
    size = options[:size]
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def can_destroy_user? user
    current_user.admin? && !current_user?(user)
  end
end
