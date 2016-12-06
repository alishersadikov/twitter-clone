require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe "validations" do
    it "is invalid without user_id" do
      tweet = Tweet.new(content: "content")

      expect(tweet).to be_invalid
    end

    it "is invalid with content and user_id" do
      user = User.create(name: "ali", email: "al@al.com", password: "password1", password_confirmation: "password1")
      tweet = Tweet.new(content: "content", user_id: user.id)

      expect(tweet).to be_valid
    end

    it "is invalid with content too long" do
      user = User.create(name: "ali", email: "al@al.com", password: "password1", password_confirmation: "password1")
      content = "a" * 141
      tweet = Tweet.new(content: content, user_id: user.id)

      expect(tweet).to be_invalid
    end
  end

  describe "relationships" do
    it "belongs to a user" do
      user = User.create(name: "ali", email: "al@al.com", password: "password1", password_confirmation: "password1")
      tweet = Tweet.new(content: "content", user_id: user.id)

      expect(tweet).to respond_to(:user)
    end
  end
end
