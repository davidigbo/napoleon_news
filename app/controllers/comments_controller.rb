class CommentsController < ApplicationController
  before_action :set_article

  def create
    @comment = @article.comments.build(comment_params)
    @comment.author = current_user
    
    if @comment.save
      redirect_to request.referer || root_path, notice: "Comment added successfully."
    else
      redirect_to request.referer || root_path, alert: "Failed to add comment."
    end
  end

  def destroy
    head :unauthorized unless current_user&.admin?
    
    @comment = Comment.find(params[:id])
    @comment.discard
    redirect_to request.referer
  end

  private

  def set_article
    @article = Article.friendly.find(params[:article_slug])
  end

  def comment_params
    params.require(:comment).permit(:body, :comment_type)
  end
end