class PagesController < ApplicationController

  def index
    @page_title = "Home"
  end

  def contact
    @page_title = "Contact"
  end

  def about
    @page_title = "About"
  end

end
