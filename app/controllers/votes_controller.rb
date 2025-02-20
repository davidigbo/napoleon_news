class VotesController < ApplicationController
  before_action :authenticate_user!

  # def create
  #   @contest = Contest.find(params[:contest_id])
  #   @contestant = @contest.contestants.friendly.find(params[:contestant_slug])
    
  #   # Prevent duplicate votes from the same user for the same contestant
  #   if Vote.exists?(contest: @contest, contestant: @contestant, voter: current_user)
  #     flash[:alert] = "You have already voted for this contestant."
  #   else
  #     @vote = Vote.new(contest: @contest, contestant: @contestant, voter: current_user)
      
  #     if @vote.save
  #       flash[:notice] = "Thank you for voting!"
  #     else
  #       flash[:alert] = "Unable to cast vote. Please try again."
  #     end
  #   end
    
  #   redirect_back fallback_location: contest_contestant_path(@contest, @contestant)
  # end

  def create
    @contest = Contest.find(params[:contest_id])
    @contestant = @contest.contestants.friendly.find(params[:contestant_slug])
  
    if Vote.exists?(contest: @contest, contestant: @contestant, voter: current_user)
      @message = "You have already voted for this contestant."
    else
      @vote = Vote.new(contest: @contest, contestant: @contestant, voter: current_user)
  
      if @vote.save
        @message = "Thank you for your vote!"
      else
        @message = "Unable to cast vote. Please try again."
      end
    end
  
    respond_to do |format|
      format.js # This will render `create.js.erb`
      format.html { redirect_back fallback_location: contest_contestant_path(@contest, @contestant) }
    end
  end
  
end