require 'spec_helper'

describe User do

  before(:each) do
    @usr = {:name => 'Test User', :email => 'test@test.org'}
  end

  it "should create a new instance when given attributes" do
    User.create!(@usr)
  end

  it "should require name" do
    user_no_name = User.new(@usr.merge(:name => ''))
    user_no_name.should_not be_valid
  end

  it "should require email" do
    user_no_email = User.new(@usr.merge(:email => ''))
    user_no_email.should_not be_valid
  end

  it "should reject name over 50 characters" do
    user_name = 'a' * 51
    new_user = User.new(@usr.merge(:name => user_name))
    new_user.should_not be_valid
  end

  it "should accept only valid email" do
    sample_email = %w[sample.email@text.com ThIS_SAMPLE@sample.email.com another@email.com]
    sample_email.each do |email|
      new_user = User.new(@usr.merge(:email => email))
      new_user.should be_valid
    end
  end

  it "should reject invalid email" do
    sample_email = %w[sample.email@text,com ThIS_SAMPLE_sample.email.com another@email.]
    sample_email.each do |email|
      new_user = User.new(@usr.merge(:email => email))
      new_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@usr)
    new_user = User.new(@usr)
    new_user.should_not be_valid
  end

  it "should mark as duplicate email addresses unless different case" do
    upcase_email = @usr[:email].upcase
    User.create!(@usr.merge(:email => upcase_email))
    new_user = User.new(@usr)
    new_user.should_not be_valid
  end
end
