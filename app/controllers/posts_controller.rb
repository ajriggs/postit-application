class PostsController < ApplicationController
  before_action :fetch_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]
  before_action :require_author, only: [:edit, :update]

  helper_method :author

  def index
    @posts = Post.sorted_index
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.author = current_user
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
    if @post.update(post_params)
      flash[:notice] = "Thanks for sharing your thoughts!"
      redirect_to post_path(@post)
    else
      render(:edit)
    end
  end

  def vote
    vote = @post.votes.create(vote: params[:vote], user: current_user, voteable: @post)
    if vote.valid?
      flash[:notice] = 'Vote tallied'
      redirect_to :back
    else
      flash[:error] = "Oops! Something went wrong. Try again? Note: you cannot vote on anything more than once."
      redirect_to(:back)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end

  def fetch_post
    @post = Post.find(params[:id])
  end

  def author
    @post.author == current_user
  end

  def require_author
    unless author
      flash[:error] = 'You cannot edit a post you did not author.'
      redirect_to post_path(@post)
    end
  end

end
