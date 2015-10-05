class PostsController < ApplicationController
  before_action :fetch_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]
  before_action :require_author, only: [:edit, :update]

  helper_method :user_has_author_permissions?


  def index
    @posts = Post.sorted_index
    respond_to do |format|
      format.html
      format.json { render json: @posts }
      format.xml { render xml: @posts }
    end
  end

  def show
    @comment = Comment.new
    respond_to do |format|
      format.html
      format.json { render json: @post }
      format.xml { render xml: @post }
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new post_params
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
    if @post.update post_params
      flash[:notice] = "Thanks for sharing your thoughts!"
      redirect_to post_path(@post)
    else
      render :edit
    end
  end


  # need to figure out how to get my error messages back after ajaxifying this code
  def vote
    @vote = @post.votes.create(vote: params[:vote], user: current_user, voteable: @post)

    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = "Your vote was tallied."
        else
          flash[:error] = 'You cannot vote twice.'
        end
        redirect_to :back
      end
      format.js
    end
  end

  private

  def fetch_post
    @post = Post.find_by slug: params[:id]
  end

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end

  def user_has_author_permissions?
    logged_in? && (current_user == @post.author || current_user.is_admin?)
  end

  def require_author
    access_denied unless user_has_author_permissions?
  end

end
