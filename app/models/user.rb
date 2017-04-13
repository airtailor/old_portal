class User < ActiveRecord::Base
  has_many :orders, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  # validates :password, presence: true, length: { minimum: 5 }

  def is_admin?
    # @TODO Make this better.
    self.email == "orders@airtailor.com"
  end

  def is_burberry?
    self.email == "test@burberry.com"
  end


end
