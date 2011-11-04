require 'spec_helper'

describe PagesController do
  render_views

  before :each do
    @base_title = "Small Tweet"
  end

  describe "GET 'index'" do
    describe "when not signed in" do
      it "should be successful" do
        get 'index'
        response.should be_success
      end

      it "should have the correct title" do
        get 'index'
        response.should have_selector("title", :content => "#{@base_title} | Home")
      end

      it "should not have an empty body tag" do
        get 'index'
        response.body.should_not =~ /<body>\s*<\/body>/
      end
    end

    describe "when signed in" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        other_user = Factory(:user, :email => Factory.next(:email))
        other_user.follow!(@user)
      end

      it "should have the right follower/following links" do
        get 'index'
        response.should have_selector('a', :href => following_user_path(@user))
        response.should have_selector('a', :href => followers_user_path(@user))
      end
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the correct title" do
      get 'contact'
      response.should have_selector("title", :content => "#{@base_title} | Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the correct title" do
      get 'about'
      response.should have_selector("title", :content => "#{@base_title} | About")
    end
  end

end
