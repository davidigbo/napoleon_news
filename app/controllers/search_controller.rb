class SearchController < ApplicationController
  def index
    @query = params[:query]
    @results = if @query.present?
                 # Replace with your actual search model and conditions
                 Article.published.where("title ILIKE ?", "%#{@query}%").order(published_at: :desc).limit(6)
               else
                 []
               end
    
    # Only respond to HTML format
    respond_to do |format|
      format.html
    end
    
    # If it's a turbo frame request, render the partial only
    if turbo_frame_request?
      render partial: "search/results", locals: { results: @results }
      # render partial: "search/results_frame", locals: { results: @results }

    end
  end

    
  private
  
  # Helper method to check if it's a turbo frame request
  def turbo_frame_request?
    request.headers["Turbo-Frame"].present?
  end
end