class ReviewArticleController < ApplicationController
  before_action :authenticate_user!

  def show
    @article = Article.includes(:comments).friendly.find(params[:slug])
    
    head :unauthorized unless current_user&.admin? || current_user&.editor? || current_user == @article.author

    
    article_image = @article.image
    @article_image_url = article_image.present? ? url_for(article_image) : nil
    # @article_body = @article_image_url.present? ? @article.body_without_images : @article.body
    @article_body = @article.body
    @comments = @article.comments.review_comment.order(created_at: :desc)
  end
end