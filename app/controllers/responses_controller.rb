class ResponsesController < ApplicationController
  def create
    @response = Response.new(response_params)
    if @response.save
      redirect_to quiz_path(@response.quiz), notice: "Response saved successfully."
    else
      redirect_to quiz_path(@response.quiz), alert: "Error saving response."
    end
  end

  private

  def response_params
    params.require(:response).permit(:quiz_id, :question_id, :user_id)
  end
end
