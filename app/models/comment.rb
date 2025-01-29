class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :commentable, polymorphic: true

  enum :comment_type, [review_comment: 0, reader_comment: 1]

  validates :content, presence: true
end
