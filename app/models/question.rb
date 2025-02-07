class Question < ApplicationRecord

    has_many :options, dependent: :destroy
    has_many :quiz_questions, dependent: :destroy
    has_many :quizzes, through: :quiz_questions

    validates :question_text, presence: true
    validates :correct_answer, presence: true
end
