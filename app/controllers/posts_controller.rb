class PostsController < ApplicationController
  before_action :fetch_post, only: [:show, :edit, :update]

  def index
    @posts = Post.all
  end

  def show
    @comment = @post.comments.new(post_id: @post.id, author: User.first)
    # above line contains temporarily-hardcoded user, until authentication works
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.category_ids = params[:post][:category_ids]
    @post.author = User.first #temporary, until authentication works
    if @post.save
      flash[:notice] = "Thanks for sharing your thoughts!"
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    @post.update(post_params)
    @post.category_ids = params[:post][:category_ids]
    binding.pry
    if @post.save
      flash[:notice] = "Thanks for sharing your thoughts!"
      redirect_to posts_path
    else
      render :edit
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :description)
  end

  def fetch_post
    @post = Post.find(params[:id])
  end

end
