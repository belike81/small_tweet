class PagesController < ApplicationController

  def index
    @page_title = "Home"
    if signed_in?
      @post = Post.new
      @feed = current_user.feed.paginate(:page => params[:page])
    end
  end

  def contact
    @page_title = "Contact"
  end

  def about
    @page_title = "About"
  end

end
