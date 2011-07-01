require 'spec_helper'

describe User do

  before(:each) do
    @usr = {
        :name => 'Test User',
        :email => 'test@test.org',
        :password => 'password',
        :password_confirmation => 'password'
    }
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

  describe "passwords" do

    before(:each) do
      @user = User.new(@usr)
    end

    it "should have a password field" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation" do
      @user.should respond_to(:password_confirmation)
    end

    it "should require a password" do
      User.new(@usr.merge(:password => '', :password_confirmation => '')).should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@usr.merge(:password_confirmation => 'invalid')).should_not be_valid
    end

    it "should reject short password" do
      pass = "a" * 3
      pass_hash = @usr.merge(:password => pass, :password_confirmation => pass)
      User.new(pass_hash).should_not be_valid
    end

    it "should reject long password" do
      pass = "a" * 31
      pass_hash = @usr.merge(:password => pass, :password_confirmation => pass)
      User.new(pass_hash).should_not be_valid
    end

    describe "password encryption" do

      before(:each) do
        @user = User.create!(@usr)
      end

      it "should have encrypted password" do
        @user.should respond_to(:encrypted_password)
      end

      it "should set the encrypted password attribute" do
        @user.encrypted_password.should_not be_blank
      end

    end

  end

end
