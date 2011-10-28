class UsersController < ApplicationController

  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :approve_user, :only => [:edit, :update]
  before_filter :check_admin, :only => [:destroy]

  def index
    @users = User.paginate(:page => params[:page])
    @page_title = 'Users list'
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(:page => params[:page])
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

  def edit
    @page_title = "Edit user"
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => "Your profile has been updated" }
    else
      @page_title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path, :flash => { :success => "User has been deleted!" }
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def approve_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user? @user
    end

    def check_admin
      user = User.find(params[:id])
      redirect_to root_path unless (current_user.admin? && !current_user?(user))
    end

end
