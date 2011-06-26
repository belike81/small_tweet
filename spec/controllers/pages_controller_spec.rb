require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end

    it "should have the correct title" do
      get 'index'
      response.should have_selector("title", :content => "Small Twitter")
    end

    it "should not have an empty body tag" do
      get 'index'
      response.body.should_not =~ /<body>\s*<\/body>/
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the correct title" do
      get 'contact'
      response.should have_selector("title", :content => "Small Twitter | Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the correct title" do
      get 'about'
      response.should have_selector("title", :content => "Small Twitter | About")
    end
  end

end
