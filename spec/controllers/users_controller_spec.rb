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

      it "should sign user in" do
        post :create, :user => @usr
        controller.should be_signed_in
      end
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      test_sign_in(@user)
    end

    it "should be sucesfull" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector('title', :content => "Edit user")
    end

    it "should have a link to change a gravatar" do
      get :edit, :id => @user
      response.should have_selector('a', :href => 'http://gravatar.com/emails')
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      test_sign_in(@user)
    end

    describe "failure" do
      before :each do
        @usr = {:name => "", :email => "", :password => "", :password_confirmation => ""}
      end

      it "should render the edit user page" do
        put :update, :id => @user, :user => @usr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @user, :user => @usr
        response.should have_selector('title', :content => "Edit user")
      end
    end

    describe "success" do
      before(:each) do
        @usr = { :name => "New name", :email => "user@example.com", :password => "newpass", :password_confirmation => "newpass" }
      end

      it "should change the user's attributes" do
        put :update, :id => @user, :user => @usr
        user = assigns(:user)
        @user.reload
        @user.name.should == user.name
        @user.email.should == user.email
        @user.encrypted_password.should == user.encrypted_password
      end

      it "should have a flash message" do
        put :update, :id => @user, :user => @usr
        flash[:success].should =~ /updated/i
      end
    end
  end

end
