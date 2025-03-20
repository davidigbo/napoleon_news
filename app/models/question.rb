class Question < ApplicationRecord
  has_many :quiz_questions
  has_many :quizzes, through: :quiz_questions
  
  validates :question_text, presence: true
  validates :correct_answer, presence: true
  validates :api_question_id, presence: true, uniqueness: true
  
  # Serialize incorrect_answers as an array
  # serialize :incorrect_answers, Array
  attribute :incorrect_answers, :json, default: []


  # Find or create from API data
  def self.find_or_create_from_api(api_data)
    question = find_by(api_question_id: api_data[:api_question_id])
    
    return question if question.present?
    
    create(
      question_text: api_data[:question_text],
      correct_answer: api_data[:correct_answer],
      api_question_id: api_data[:api_question_id],
      incorrect_answers: api_data[:incorrect_answers]
    )
  end
end
