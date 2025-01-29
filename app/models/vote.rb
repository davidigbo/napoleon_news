class Vote < ApplicationRecord
  belongs_to :contestant
  belongs_to :voter

  after_create :broadcast_leaderborad_update

  private

  def broadcast_leaderborad_update
    ActionCable.server.broadcast("leaderboard_#{contest_id}", { message: "New vote cast!", contestants: Contestant.left_joins(:votes).group(:id).order("count(votes.id) DESC")})
  end
end
