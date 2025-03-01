# class CommentsController < ApplicationController
#   before_action :set_article

#   def create
#     @comment = @article.comments.build(comment_params)
#     @comment.author = current_user
    
#     if @comment.save
#       redirect_to request.referer || root_path, notice: "Comment added successfully."
#     else
#       redirect_to request.referer || root_path, alert: "Failed to add comment."
#     end
#   end

#   def destroy
#     head :unauthorized unless current_user&.admin?
    
#     @comment = Comment.find(params[:id])
#     @comment.discard
#     redirect_to request.referer
#   end

#   private

#   def set_article
#     @article = Article.friendly.find(params[:article_slug])
#   end

#   def comment_params
#     params.require(:comment).permit(:body, :comment_type)
#   end
# end


class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.author = current_user

    if @comment.save
      flash[:notice] = "Comment posted successfully."
    else
      flash[:alert] = "Failed to post comment."
    end

    redirect_to request.referer || root_path
  end

  def destroy
    head :unauthorized unless current_user&.admin?
    
    @comment = Comment.find(params[:id])
    @comment.discard
    flash[:notice] = "Comment deleted successfully."
    redirect_to request.referer
  end

  private

  def set_commentable
    if params[:article_slug]
      @commentable = Article.friendly.find(params[:article_slug])
    elsif params[:contestant_slug]
      @commentable = Contestant.friendly.find(params[:contestant_slug])
    else
      render plain: "Invalid commentable type", status: :unprocessable_entity
    end
  end

  def comment_params
    params.require(:comment).permit(:body, :comment_type)
  end
end

