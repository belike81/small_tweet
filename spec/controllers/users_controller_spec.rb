require 'spec_helper'

describe UsersController do
  render_views

  before(:each) do
    @user = Factory(:user)
  end
  
  describe "GET show" do
    it "should be successful" do
      get :show, :id => @user.id
      response.should be_success
    end

    it "should have a correct title" do
      get :show, :id => @user.id
      response.should have_selector('title', :content => @user.name)
    end

    it "should find the active user" do
      get :show, :id => @user.id
      assigns(:user).should == @user
    end

    it "should display users name" do
      get :show, :id => @user.id
      response.should have_selector('h1', :content => @user.name)
    end

    it "should have user gravatar" do
      get :show, :id => @user.id
      response.should have_selector('img', :class => 'gravatar')
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have a correct title" do
      get :new
      response.should have_selector('title', :content => 'Sign Up')
    end
  end

end
