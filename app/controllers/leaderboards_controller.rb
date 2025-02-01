class LeaderboardsController < ApplicationController
  
  def index
      
      @contest = Contest.find(params[:contest_id])
      @contestants = @contest.contestants.left_joins(:votes)
                                .select('contestants.*, COUNT(votes.id) AS votes_count')
                                .group(:id)
                                .order('votes_count DESC')
      @total_votes = @contestants.sum { |c| c.votes.count }
  
      respond_to do |format|
        format.html
        format.json { render json: @contestants }
      end
    end


end
