class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :content, presence: true,
                      length: {maximum: Settings.microposts.max_content}
  validates :image, content_type: {
                      in: Settings.microposts.image_type,
                      message: I18n.t("microposts.content_type.message")
                    },
                    size: {
                      less_than: Settings.microposts.max_size.megabytes,
                      message: I18n.t("microposts.size.message")
                    }

  scope :newest, ->{order(created_at: :desc)}
  scope :by_user, ->(user_ids){where user_id: user_ids}

  delegate :name, to: :user, prefix: true

  def display_image
    image.variant(
      esize_to_limit: [Settings.microposts.limit, Settings.microposts.limit]
    )
  end
end
