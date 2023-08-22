class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.users.max_name}

  validates :email, presence: true,
                    length: {maximum: Settings.users.max_email},
                    format: {with: Settings.users.email_regex},
                    uniqueness: true

  has_secure_password
  validates :password, presence: true,
                      length: {minimum: Settings.users.min_password}

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost
  end

  private
  def downcase_email
    email.downcase!
  end
end
