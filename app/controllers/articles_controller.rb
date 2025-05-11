require 'nokogiri'

class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy, :update_status]
  before_action :authenticate_user!, only: [:create, :update, :destroy, :new, :edit]

  # def index
  #   @articles = Article.includes(:author).order(created_at: :desc).page(params[:page]).per(10)

  #   respond_to do |format|
  #     format.html
  #     format.json do
  #       render json: { 
  #         articles: @articles, 
  #         meta: { total_pages: @articles.total_pages, total_count: @articles.total_count }
  #       }
  #     end
  #   end
  # end

  def index
    @articles_under_review = Article.under_review.order(created_at: :desc).page(params[:page]).per(20)
    @published_articles = Article.published.order(created_at: :desc).page(params[:page]).per(20)
  end

  def new
    head :unauthorized unless current_user&.author? || current_user&.admin? || current_user&.editor?

    @article = Article.new
    respond_to do |format|
      format.html { render :new, status: :ok }
    end
  end

  def edit
    head :unauthorized unless @article.author == current_user || current_user&.admin? || current_user&.editor?

    respond_to do |format|
      format.html { render :edit, status: :ok }
    end
  end

  def show
    article_image = @article.image
    @article_image_url = article_image.present? ? url_for(article_image) : nil
    # @article_body = @article_image_url.present? ? @article.body_without_images : @article.body
    @article_body = @article.body
    @comments = @article.comments.reader_comment.order(created_at: :desc)

    @related_articles = Article.joins(:categories).where(categories: {id: @article.category_ids}, status: 'published')
      .where.not(id: @article.id)
      .order(published_at: :desc)
      .distinct.limit(3)

    set_meta_tags title: @article.title,
                  description: @article.description,
                  keywords: @article.tags.map(&:name).join(', '),
                  canonical: article_url(@article),
                  og: {
                    title: @article.title,
                    description: @article.description,
                    image: @article_image_url,
                    url: article_url(@article),
                    type: 'article'
                  },
                  twitter: {
                    card: 'summary_large_image',
                    site: '@napoleonnewstv',
                    title: @article.title,
                    description: @article.description,
                    image: @article_image_url
                  }
                  
    if @article.published?      
      track_page_view(
        page_type: "article",
        page_id: @article.id,
      )
    end

    respond_to do |format|
      format.html
      format.json { render json: @article }
    end
  end

  def create
    # head :unauthorized unless @article.author == current_user || current_user&.admin? || current_user&.editor?

    @article = Article.build(article_params)

    if @article.save
      respond_to do |format|
        format.html { redirect_to @article, notice: "Article was successfully created." }
        format.json { render json: @article, status: :created }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    head :unauthorized unless @article.author == current_user || current_user&.admin? || current_user&.editor?

    modified_params = if article_params[:status] == 'published' && article_params[:published_at] == 'now' # Direct publishing from under_review
                        article_params.merge(published_at: Time.current, approved_at: Time.current, approved_by: current_user)
                      elsif article_params[:status] == 'approved' && article_params[:published_at].present? # Approve and schedule
                        published_at_local = article_params[:published_at]
                        time_zone = article_params[:time_zone]
                        time_zone_obj = ActiveSupport::TimeZone[time_zone]
                        published_at_with_zone = time_zone_obj.parse(published_at_local)
                        article_params.merge(published_at: published_at_with_zone)
                      elsif article_params[:status] == 'approved' && article_params[:published_at].blank? # Approve and keep in bucket
                        article_params.merge(approved_at: Time.current, approved_by: current_user)
                      end

    modified_params = modified_params&.except(:time_zone) || article_params.except(:time_zone)

    if @article.update(modified_params)
      respond_to do |format|
        format.html { redirect_to @article, notice: "Article was successfully updated." }
        format.json { render json: @article, status: :ok }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    head :unauthorized unless @article.author == current_user || current_user&.admin? || current_user&.editor?
    
    @article.discard

    respond_to do |format|
      format.html { redirect_to request.referer || root_path, notice: "Article was deleted successfully." }
      format.json { head :no_content }
    end
  end

  def update_status
    status = params[:status]
    notice = case status
             when 'draft'
              'Article is now marked as draft!'
             when 'under_review'
              'Article has been submitted for review!'
             when 'approved'
              'Article has been approved for publishing!'
             when 'published'
              'Article has been published successfully'
             end

    if @article.update(status: status)
      redirect_to request.referer || root_path, notice: notice
    else
      redirect_to request.referer, alert: "Failed to update article status"
    end
  end

  private

  def set_article
    @article = Article.friendly.find(params[:slug])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to articles_url, alert: "Article not found." }
      format.json { render json: { error: "Article not found" }, status: :not_found }
    end
  end

  def article_params
    params.require(:article).permit(:title, :body, :description, :status, :published_at, :approved_at, :tag_list, :time_zone, :author_id, :anonymize, category_ids: [])
  end
end
