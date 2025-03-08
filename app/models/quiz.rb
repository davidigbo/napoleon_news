class Quiz < ApplicationRecord
  belongs_to :user
  has_many :quiz_questions, dependent: :destroy
  has_many :questions, through: :quiz_questions
  
  validates :completed, inclusion: { in: [true, false] }
  validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end
