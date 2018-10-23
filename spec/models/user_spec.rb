require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#create' do
  
    before(:each) { @user = User.new(name: "Bob", email: "flammy@zoo.com", password: "foobar", password_confirmation: "foobar") }

    it "is valid with all proper parameters supplied" do
      expect(@user).to be_valid
    end

    it "is not valid with a missing email" do
      @user.email = nil
      expect(@user).to_not be_valid
    end

    it "is not valid with an email consisting of only spaces" do
      @user.email = "   "
      expect(@user).to_not be_valid
    end

    it "is not valid with a malformed email" do
      @user.email = "flammy.at.com"
      expect(@user).to_not be_valid
    end

    it "is not valid without a name" do
      @user.name = nil
      expect(@user).to_not be_valid
    end

    it "is not valid with a name consisting of only spaces" do
      @user.name = "   "
      expect(@user).to_not be_valid
    end

    it "is not valid if missing a password" do
      @user.password = nil
      @user.password_confirmation = nil
      expect(@user).to_not be_valid
    end

    it "is not valid if password just has spaces" do
      @user.password = " " * 10
      @user.password_confirmation = " " * 10
      expect(@user).to_not be_valid
    end

    it "is not valid with a password with too few characters" do
      @user.password = "foo"
      @user.password_confirmation = "foo"
      expect(@user).to_not be_valid
    end

    it "is not valid if password and confirmation do not match" do
      @user.password = "raul"
      @user.password_confirmation = "charles"
      expect(@user).to_not be_valid
    end

    it "is invalid if password has too few characters" do
      @user.password = "a" * 5
      expect(@user).to_not be_valid
    end

    it "is invalid if a name is too long" do
      @user.name = "a" * 51
      expect(@user).to_not be_valid
    end

    it "is valid if a name is not too long" do
      @user.name = "a" * 50
      expect(@user).to be_valid
    end

    it "is invalid if an email is too long" do
      @user.name = "a" * 255 + "@fred.com"
      expect(@user).to_not be_valid
    end

    it "should not allow duplicate email addresses" do
      @userdup = User.new(name: "Ted", email: "flammy@zoo.com", password: "mrfoobar", password_confirmation: "mrfoobar")
      @user.save
      expect(@userdup).to_not be_valid
    end

    it "should not allow duplicate email addresses even if their case is different" do
      @userdup = User.new(name: "Sam", email: "FlamMY@ZOO.com", password: "mrfoobar", password_confirmation: "mrfoobar")
      @user.save
      expect(@userdup).to_not be_valid
    end


  end
end
