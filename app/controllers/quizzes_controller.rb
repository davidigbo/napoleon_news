class QuizzesController < ApplicationController
  def index
    @quiz = Quiz.order("RANDOM()").first
  end

  def show
    @quiz = Quiz.find(params[:id])
  end

  def start
    @quiz = Quiz.find(params[:id])
    render json: { quiz: @quiz, questions: @quiz.questions }
  end
end
