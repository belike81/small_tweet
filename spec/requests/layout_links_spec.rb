require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home Page at '/'" do
    get '/'
    response.should have_selector('title', :content => 'Home')
  end

  it "should have a Contact Page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => 'Contact')
  end

  it "should have a About Page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => 'About')
  end

  it "should have a Sign Up Page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => 'Sign Up')
  end

  it "should have a Sign In Page at '/signin'" do
    get '/signin'
    response.should have_selector('title', :content => 'Sign In')
  end

  it "should have correct paths from the main menu" do
    visit root_path
    response.should have_selector('title', :content => 'Home')
    click_link 'sign up'
    response.should have_selector('title', :content => 'Sign Up')
    click_link 'About'
    response.should have_selector('title', :content => 'About')
    click_link 'Contact'
    response.should have_selector('title', :content => 'Contact')
  end

  describe "when not signed in" do
    it "should have a sign in link" do
      visit root_path
      response.should have_selector('a', :href => signin_path )
    end
  end

  describe "when signed in" do
    before(:each) do
      @usr = Factory(:user)
      visit signin_path
      fill_in :email, :with => @usr.email
      fill_in :password, :with => @usr.password
      click_button
    end
    it "should have a sign out link" do
      visit root_path
      response.should have_selector('a', :href => signout_path )
    end

    it "should have a profile link" do
      visit root_path
      response.should have_selector('a', :href => user_path(@usr) )
    end

    it "should have an edit profile link" do
      visit user_path(@usr)
      response.should have_selector('a', :href => edit_user_path(@usr))
    end
  end
  
  describe "menu links when user is not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector('a', :href => signin_path)
    end
  end

  describe "menu links when user is signed in" do
    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in :email, :with => @user.email
      fill_in :password, :with => @user.pasword
    end
  end

end
