class UsersController < ApplicationController

  before_filter :authenticate, :only => [:edit, :update]
  before_filter :approve_user, :only => [:edit, :update]

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
<<<<<<< HEAD
      sign_in @user
=======
      sign_in(@user)
>>>>>>> 2785c6b2f8afed40188086e8b78d5a5ad6377b06
      redirect_to @user, :flash => { :success => "Your account has been successfully created" }
    else
      @page_title = "Sign Up"
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @page_title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => "Your profile has been updated" }
    else
      @page_title = "Edit user"
      render 'edit'
    end
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def approve_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user? @user
    end

end
