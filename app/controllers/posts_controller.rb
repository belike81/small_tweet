class PostsController < ApplicationController
  before_filter :authenticate

  def create
    @post = current_user.posts.build(params[:post])
    if @post.save
      redirect_to root_path, :flash => { :success => "Post created" }
    else
      render 'pages/index'
    end
  end

  def destroy
  end
end
