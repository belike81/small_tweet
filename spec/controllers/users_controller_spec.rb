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

  describe "POST 'create'" do
    describe "failure" do
      before :each do
        @usr = {:name => "", :email => "", :password => "", :password_confirmation => ""}
      end

      it "should have the right title" do
        post :create, :user => @usr
        response.should have_selector('title', :content => 'Sign Up')
      end

      it "should render the 'new' page" do
        post :create, :user => @usr
        response.should render_template('new')
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @usr
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      before :each do
        @usr = { :name => "Test", :email => "test@test.com", :password => "password", :password_confirmation => "password" }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @usr
        end.should change(User, :count).by(1)
      end

      it "should redirect to user show page" do
        post :create, :user => @usr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a flash message" do
        post :create, :user => @usr
        flash[:success].should =~ /your account has been successfully created/i
      end
    end
  end

end
