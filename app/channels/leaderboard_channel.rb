class LeaderboardChannel < ApplicationCable::Channel
  def subscribed
    stream_for contest
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def contest
    @contest ||= Contest.find(params[:contest_id])
  end
end
