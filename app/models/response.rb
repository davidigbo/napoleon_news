class Response < ApplicationRecord
  belongs_to :quiz
  belongs_to :question
  belongs_to :user
end
