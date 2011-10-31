module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:token] = [user.id, user.salt]
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:token)
    current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_token
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete :token
    self.current_user = nil
  end

  def deny_access
    session[:referer] = request.fullpath
    redirect_to signin_path, :flash => { :success => "Please sign in to access this page" }
  end

  def authenticate
    deny_access unless signed_in?
  end

  def redirect_back(default)
    redirect_to session[:referer] || default
    session[:referer] = nil
  end

  private

  def user_from_token
    User.authenticate_with_salt(*token)
  end

  def token
    cookies.signed[:token] || [nil, nil]
  end

end