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

      it "should have a salt" do
        @user.should respond_to(:salt)
      end

      describe "has_password? method" do
        it "should exist" do
          @user.should respond_to(:has_password?)
        end

        it "should return true if passwords match" do
          @user.has_password?(@usr[:password]).should be_true
        end

        it "should return false if passwords don't match" do
          @user.has_password?('invalid_password').should be_false
        end
      end

      describe "authenticate method" do
        it "should exist" do
          User.should respond_to(:authenticate)
        end

        it "should return nil on password mismatch" do
          User.authenticate(@usr[:email], 'invalid_password').should be_nil
        end

        it "should return nil on email mismatch" do
          User.authenticate('invalid_email', @usr[:password]).should be_nil
        end

        it "should return the user on email and password match" do
          User.authenticate(@usr[:email], @usr[:password]).should == @user
        end
      end
    end
  end

  describe "admin attribute" do
    before(:each) do
      @user = User.create!(@usr)
    end

    it "should have an admin attribute" do
      @user.should respond_to(:admin)
    end

    it "should not be admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

  describe "post association" do
    before(:each) do
      @user = User.create!(@usr)
      @p1 = Factory(:post, :user => @user, :created_at => 1.day.ago)
      @p2 = Factory(:post, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have a posts attribute" do
      @user.should respond_to(:posts)
    end

    it "should have the right posts order" do
      @user.posts.should == [@p2, @p1]
    end

    it "should destroy associated posts" do
      @user.destroy
      [@p1, @p2].each do |post|
        Post.find_by_id(post.id).should be_nil
      end
    end

    describe "users feed" do
      it "should display the feed" do
        @user.should respond_to(:feed)
      end

      it "should include user's posts" do
        @user.feed.should include(@p1)
        @user.feed.should include(@p2)
      end

      it "should not include non user posts" do
        p3 = Factory(:post, :user => Factory(:user, :email => Factory.next(:email)), :created_at => 1.hour.ago)
        @user.feed.should_not include(p3)
      end
    end
  end

  describe "relationships" do
    before(:each) do
      @user = User.create!(@usr)
      @followed = Factory(:user)
    end

    it "should have a relationship method" do
      @user.should respond_to(:relationships)
    end

    it "should have a following? method" do
      @user.should respond_to(:following?)
    end

    it "should have a follow! method" do
      @user.should respond_to(:follow!)
    end

    it "should follow another user" do
      @user.follow!(@followed)
      @user.should be_following(@followed)
    end

    it "should include the followed user in the following array" do
      @user.follow!(@followed)
      @user.following.should include(@followed)
    end

    it "should have an unfollowe method" do
      @user.should respond_to(:unfollow!)
    end

    it "should unfollow the user" do
      @user.follow!(@followed)
      @user.unfollow!(@followed)
      @user.should_not be_following(@followed)
    end

    it "should have a reverse relationships method" do
      @user.should respond_to(:reverse_relationships)
    end

    it "should have a followers method" do
      @user.should respond_to(:followers)
    end

  end
end
