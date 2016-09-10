class User < ActiveRecord::Base
  has_many :orders
  has_secure_password
  validates :email, uniqueness: true

  def is_admin?
    # @TODO Make this better.
    self.email == "brian@airtailor.com"
  end
end
