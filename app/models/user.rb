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

  private
  def downcase_email
    email.downcase!
  end
end
