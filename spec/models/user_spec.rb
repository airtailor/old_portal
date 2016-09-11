require 'rails_helper'

RSpec.describe User, type: :model do

  ADMIN_EMAIL = "brian@airtailor.com"
  USER_EMAIL = "blah@blah.com"
  USER_PASSWORD = "12345"

  describe "password validations" do
    before(:each) do
      @user = User.new
      @user.email = ADMIN_EMAIL
    end

    it "requires a password" do
      @user.password = nil
      expect(@user).to_not be_valid
    end

    it "requires passwords to be at least 5 characters" do
      @user.password = "1"
      expect(@user).to_not be_valid
    end

    it "allows password >= 5 characters long" do
      @user.password = USER_PASSWORD
      expect(@user).to be_valid
    end
    
  end

  describe "email validations" do
    before(:each) do
      @user = User.new
      @user.password = "12345"
    end

    it "checks for invalid emails" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo., foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).to_not be_valid
        expect(@user.errors[:email]).to include("is invalid")
      end
    end

    it "must be unique" do
      valid_user = User.create(:email => ADMIN_EMAIL, :password => USER_PASSWORD)
      duplicate_user = User.new(:email => ADMIN_EMAIL, :password => USER_PASSWORD)
      expect(duplicate_user).to_not be_valid
      expect(duplicate_user.errors[:email]).to include("has already been taken")
    end

    it "allows valid emails" do
      @user.email = ADMIN_EMAIL
      expect(@user).to be_valid
    end
end


  # this test may need to be updated when validation for is_admin? is improved
  describe "Self.is_admin?" do
    it "returns true if user is admin" do
      user = User.create(:email => ADMIN_EMAIL)
      expect(user.is_admin?).to eq(true)
    end

    it "returns false if user is not admin" do
      user = User.create(:email => USER_EMAIL)
      expect(user.is_admin?).to eq(false)
    end
  end

end
