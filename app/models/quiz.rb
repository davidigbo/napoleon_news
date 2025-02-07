class Quiz < ApplicationRecord
  belongs_to :user
  has_many :quiz_questions, dependent: :destroy
  has_many :questions, through: :quiz_questions
  has_many :responses, dependent: :destroy

  validates :title, presence: true
end
