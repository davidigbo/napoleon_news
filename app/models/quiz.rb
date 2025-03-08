class Quiz < ApplicationRecord
  belongs_to :user
  has_many :quiz_questions, dependent: :destroy
  has_many :questions, through: :quiz_questions
  
  validates :completed, inclusion: { in: [true, false] }
  validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  before_create :set_start_time


  private

  def set_start_time
    self.started_at = Time.current
  end
end
