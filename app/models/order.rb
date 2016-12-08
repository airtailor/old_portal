class Order < ActiveRecord::Base
  belongs_to :user
  # has_many :items
  # has_many :alterations, through: :items
  def self.search(search)
    where("name ILIKE ? OR shopify_id ILIKE ?", "%#{search}%", "%#{search}%")
  end

end
