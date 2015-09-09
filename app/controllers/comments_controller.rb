class CommentsController < ApplicationController
  def create
    @comment = Comment.new(params.require(:comment).permit(:body))
    @comment.post_id = params[:post_id]
    @comment.author = User.first #temporary until authentication works
    if @comment.save
      flash[:notice] = 'Your comment was posted'
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end
end
