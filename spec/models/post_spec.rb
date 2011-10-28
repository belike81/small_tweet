require 'spec_helper'

describe Post do
  before(:each) do
    @user = Factory(:user)
    @attr = { :content => "lorem ipsum" }
  end

  it "should create a new instance with valid attributes" do
    @user.posts.create!(@attr)
  end

  describe "user associations" do
    before(:each) do
      @post = @user.posts.create!(@attr)
    end

    it "should have a user attribute" do
      @post.should respond_to(:user)
    end

    it "should have the right user" do
      @post.user_id.should == @user.id
    end
  end

  describe "validations" do
    it "should have the user id" do
      Post.new(@attr).should_not be_valid
    end

    it "should require a non-blank content" do
      @user.posts.build(:content => "").should_not be_valid
    end

    it "should reject content that is too long" do
      @user.posts.build(:content => "a" * 141).should_not be_valid
    end
  end
  
end
