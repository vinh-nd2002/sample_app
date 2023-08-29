class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:   Relationship.name,
                                  foreign_key:  "follower_id",
                                  dependent:    :destroy
  has_many :passive_relationships, class_name:   Relationship.name,
                                  foreign_key:  "followed_id",
                                  dependent:    :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, presence: true, length: {maximum: Settings.users.max_name}

  validates :email, presence: true,
                    length: {maximum: Settings.users.max_email},
                    format: {with: Settings.users.email_regex},
                    uniqueness: true

  validates :password, presence: true,
                      length: {minimum: Settings.users.min_password},
                      allow_nil: true

  before_save :downcase_email
  before_create :create_activation_digest

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(
      reset_digest: User.digest(reset_token),
      reset_sent_at: Time.zone.now
    )
  end

  def feed
    Micropost.by_user(following_ids << id)
  end

  def password_reset_expired?
    reset_sent_at < Settings.users.reset_password_expired.hours.ago
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def remember
    self.remember_token = User.new_token
    update_column(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def session_token
    remember_digest || remember
  end

  def follow other_user
    following << other_user unless self == other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  private
  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
