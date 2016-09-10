class Order < ActiveRecord::Base
  belongs_to :user
  # has_many :items
  # has_many :alterations, through: :items
end
