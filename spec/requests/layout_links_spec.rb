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

end
