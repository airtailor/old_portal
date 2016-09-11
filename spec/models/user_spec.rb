require 'rails_helper'

RSpec.describe User, type: :model do

  describe "Self.is_admin?" do
    it "returns true if user is admin" do
      user = User.create(:email => "brian@airtailor.com")
      expect(user.is_admin?).to eq(true)
    end

    it "returns false if user is not admin" do
      user = User.create(:email => "blah@blah.com")
      expect(user.is_admin?).to eq(false)
    end
  end

end
