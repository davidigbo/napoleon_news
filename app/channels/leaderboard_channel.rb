class LeaderboardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "leaderboard_#{params[:contest_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
