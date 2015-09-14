class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(params.require(:comment).permit(:body))
    @comment.author = current_user

    if @comment.save
      flash[:notice] = 'Your comment was posted'
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def vote
    comment = Comment.find(params[:id])
    vote = comment.votes.create(vote: params[:vote], user: current_user, voteable: @comment)
    if vote.valid?
      flash[:notice] = 'Vote tallied'
      redirect_to(:back)
    else
      flash[:error] = 'Oops! Something went wrong. Try again? Note: you cannot vote on anything more than once.'
      redirect_to(:back)
    end
  end

end
