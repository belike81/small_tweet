require 'spec_helper'

describe "Posts" do
  before(:each) do
    user = Factory(:user)
    visit signin_path
    fill_in :email, :with => user.email
    fill_in :password, :with => user.password
    click_button
  end

  describe "creation" do

    describe "failure" do
      it "should not make a new post" do
        lambda do
          visit root_path
          fill_in :post_content, :with => ""
          click_button
          response.should render_template('pages/index')
        end.should_not change(Post, :count)
      end
    end

    describe "success" do
      it "should create a new post" do
        content = "Lorem ipsum"
        lambda do
          visit root_path
          fill_in :post_content, :with => content
          click_button
          response.should have_selector('p.post_content', :content => content)
        end.should change(Post, :count).by(1)
      end
    end

  end
end
