class HomeController < ApplicationController
  # before_action :authenticate_user!

  def index
    @articles = Article.where(status: 'published').includes(:author).order(published_at: :desc)
    .page(params[:page]).per(10)

    # @categories = {}
    # Category.all.each { |category| @categories[category.name] = category_url(category) }
    @categories = Category.roots.where.not(name: ['Carousel', 'Others'])
    @carousel_articles = Category.find_by(name: 'Carousel').articles.where(status: 'published').order(published_at: :desc).includes(:author).limit(7)

    if @carousel_articles.size != 7
      @carousel_articles = Article.where(status: 'published').includes(:author).order(published_at: :desc).limit(7)
    end

    set_meta_tags title: 'Home',
                  description: 'Latest headlines and breaking news from around the world.'
    
    track_page_view(
      page_type: "home",
    )

    respond_to do |format|
      format.html
      format.json { render json: @articles }
    end
  end
end
