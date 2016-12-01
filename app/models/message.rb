class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :conversation

  validates :text, presence: true, allow_blank: false

end
