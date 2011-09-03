class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @page_title = @user.name
  end

  def new
    @user = User.new
    @page_title = "Sign Up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to @user, :flash => { :success => "Your account has been successfully created" }
    else
      @page_title = "Sign Up"
      render 'new'
    end
  end

end
