class PagesController < ApplicationController

  def index
    @page_title = "Small Twitter"
  end

  def contact
    @page_title = "Small Twitter | Contact"
  end

  def about
    @page_title = "Small Twitter | About"
  end

end
