class LeaderboardController < ApplicationController

    # def index
    #     @contestants = Contestant.left_joins(:votes)
    #                               .group(:id)
    #                               .select("contestants.*, COUNT(votes.id) as votes_count")
    #                               .order("COUNT(votes.id) DESC")

    #     respond_to do |format|
    #         format.html
    #         format.json { render json: @contestants }
    #     end
    # end


    def index
        @contest = Contest.find(params[:contest_id]) 
        @contestants = Contestant.left_joins(:votes)
                                 .select('contestants.*, COUNT(votes.id) AS votes_count')
                                 .group(:id)
                                 .order('votes_count DESC')
    
        respond_to do |format|
          format.html
          format.json { render json: @contestants }
        end
      end


end
