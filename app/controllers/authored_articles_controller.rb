class AuthoredArticlesController < ApplicationController
  def index
    head :unauthorized unless current_user&.admin? || current_user.id == params[:author_id].to_i
    head :unprocessable_entity if params[:author_id].blank?

    @author = User.find(params[:author_id])
    @articles = @author.authored_articles.order(created_at: :desc).page(params[:page]).per(20)
  end
end