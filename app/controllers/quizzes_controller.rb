class QuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quiz, only: [:show, :update]
  
  def show
    @quiz_questions = @quiz.quiz_questions.includes(:question)
    
    render json: { 
      quiz: @quiz,
      questions: @quiz_questions.map do |qq|
        {
          id: qq.id,
          question_text: qq.question.question_text,
          correct_answer: qq.question.correct_answer,
          incorrect_answers: qq.question.incorrect_answers,
          user_answer: qq.user_answer
        }
      end
    }
  end
  
  def create
    # Check if user already has an active quiz
    # existing_quiz = current_user.quizzes.where(completed: false).first
    
    # if existing_quiz
    #   redirect_to quiz_path(existing_quiz)
    #   return
    # end
    
    # Create a new quiz with questions
    @quiz = QuizService.create_quiz_with_questions(current_user)
    
    if @quiz.persisted?
      render json: { 
        quiz: @quiz,
        questions: @quiz.quiz_questions.includes(:question).map do |qq|
          {
            id: qq.id,
            question_text: qq.question.question_text,
            correct_answer: qq.question.correct_answer,
            incorrect_answers: qq.question.incorrect_answers
          }
        end
      }
    else
      render json: { errors: @quiz.errors }, status: :unprocessable_entity
    end
  end
  
  def update
    total_questions = @quiz.quiz_questions.count
    correct_count = 0
    # Handle user's answers and calculate score
    if params[:answers].present?
      params[:answers].each do |quiz_question_id, answer|
        quiz_question = @quiz.quiz_questions.find(quiz_question_id)
        quiz_question.update(user_answer: answer)
        
        correct_count += 1 if quiz_question.correct?
      end
    end
  
    @quiz.update(
      completed: true,
      score: correct_count,
      submitted_at: Time.current,
    )
      
    render json: { 
      quiz: @quiz, 
      score: "#{correct_count}/#{total_questions}", 
      percentage: correct_count.zero? ? 0 : (correct_count.to_f / total_questions * 100).round(2) 
    }
  end
  
  private
  
  def set_quiz
    @quiz = current_user.quizzes.find(params[:id])
  end
end
