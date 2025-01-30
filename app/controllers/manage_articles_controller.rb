class ManageArticlesController < ApplicationController
  before_action :authenticate_user!, :authorize_user!

  def index
  end


  def draft
    @draft_articles = Article.draft.order(updated_at: :desc).page(params[:draft_page]).per(12)
  end

  def under_review
    @articles_for_review = Article.under_review.order(updated_at: :desc).page(params[:under_review_page]).per(12)
  end

  def published
    @published_articles = Article.published.order(updated_at: :desc).page(params[:published_page]).per(12)
  end

  def approved
    @approved_articles = Article.approved.order(updated_at: :desc).page(params[:approved_page]).per(12)
  end

  private

  def authorize_user!
    head :unauthorized unless current_user&.admin? || current_user&.editor?
  end
end