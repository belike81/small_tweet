class SessionsController < ApplicationController

  def new
    @page_title = "Sign In"
  end

  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    @page_title = "Sign In"
    if user.nil?
      flash.now[:error] = 'Invalid email or password!'
      render 'new'
    else
      sign_in user
      redirect_to user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
