class AnalyticsController < ApplicationController
  def index
    @article_metrics = {
      draft: Article.draft.size,
      under_review: Article.under_review.size,
      approved: Article.approved.size,
      published: Article.published.size
    }

    @user_metrics = {
      active: User.where(active: true).size,
      new: User.where(active: true, created_at: 7.days.ago .. Time.now).size,
      deactivated: User.where(active: false).size
    }
  end
end