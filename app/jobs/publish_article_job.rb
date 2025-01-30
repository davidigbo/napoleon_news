class PublishArticleJob < ApplicationJob
  queue_as :default

  def perform(article)
    return unless article.approved? && article.published_at.present?

    article.update(status: :published)
  end
end
