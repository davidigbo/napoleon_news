class QuizQuestion < ApplicationRecord
  belongs_to :quiz
  belongs_to :question

  def correct?
    user_answer == question.correct_answer
  end
end
