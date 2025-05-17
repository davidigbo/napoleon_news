class CategoriesController < ApplicationController
  before_action :set_category, only: [:articles, :show]

  def index
      @categories = Category.includes(:creator).order(created_at: :desc).page(params[:page]).per(10)

      respond_to do |format|
          format.html
          format.json { render json: @categories }
      end
  end

  def show
    @top_articles = @category.articles.where(status: 'published').order(created_at: :desc).limit(5)
    @other_articles = @category.articles
                            .where(status: 'published')
                            .order(created_at: :desc)
                            .offset(5)
                            .page(params[:page]).per(5)

    set_meta_tags title: @category.name,
                  description: "Read the latest news and updates from the #{@category.name} category, featuring top stories and in-depth analysis.",
                  canonical: category_url(@category)


    track_page_view(
      page_type: "category",
      page_id: @category.id,
    )

    respond_to do |format|
        format.html
        format.json { render json: { top_articles: @top_articles, other_articles: @other_articles } }
    end
  end

  def articles
      @articles = @category.articles.includes(:author)
      respond_to do |format|
          format.html
          format.json { render json: @articles }
      end
  end

  private

  def set_category
      @category = Category.friendly.find(params[:slug])
  end
end
