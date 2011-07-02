class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @page_title = @user.name
  end

  def new
    @page_title = "Sign Up"
  end

end
