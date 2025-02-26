class Comment < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }
  
  belongs_to :author, class_name: 'User'
  belongs_to :commentable, polymorphic: true

  enum comment_type: [:review_comment, :reader_comment]

  validates :body, presence: true
end
