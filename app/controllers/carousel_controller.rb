class CarouselController < ApplicationController
  # before_action :authenticate_admin! # Assuming you have admin authentication
  before_action :set_carousel_category
  
  def index
    @articles = Article.published.includes(:categories).order(created_at: :desc).limit(300)
    @carousel_articles = @carousel_category.articles.published.order(created_at: :desc)
    # @carousel_articles = @carousel_articles.size != 7 ? @articles.published.order(published_at: :desc).first(7) : @carousel_articles
  end
  
  def update
    article_ids = params[:article_ids] || []
    
    if article_ids.count != 7
      flash[:alert] = "You must pin exactly 7 articles to the carousel."
      redirect_to user_carousel_index_path
      return
    end
    
    # Begin transaction to ensure atomicity
    ActiveRecord::Base.transaction do
      # Remove all current carousel associations
      @carousel_category.article_categories.destroy_all
      
      # Add new associations
      article_ids.each do |article_id|
        ArticleCategory.create!(
          article_id: article_id,
          category_id: @carousel_category.id
        )
      end
    end
    
    flash[:notice] = "Carousel articles updated successfully"
    redirect_to user_carousel_index_path
  end
  
  private
  
  def set_carousel_category
    @carousel_category = Category.find_by(name: 'Carousel')
  end
end
