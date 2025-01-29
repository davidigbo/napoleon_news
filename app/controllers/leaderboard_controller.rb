class LeaderboardController < ApplicationController

    def index
        @contestants = Contestant.left_joins(:votes)
                                  .group(:id)
                                  .select("contestants.*, COUNT(votes.id) as votes_count")
                                  .order("COUNT(votes.id) DESC")


        # @votes = Vote.all

        # @contestants.each do |contestant|
        #     contestant.votes_count = contestant.votes.count

        #     contestant.save
        # end

        respond_to do |format|
            format.html
            format.json { render json: @contestants }
        end
    end
end
