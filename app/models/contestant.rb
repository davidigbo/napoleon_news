class Contestant < ApplicationRecord
  belongs_to :user
  belongs_to :contest
  belongs_to :approved_by, class_name: 'User', optional: true

  has_one_attached :image
  
  validates :image, content_type: [:png, :jpg, :jpeg]

  enum approved: { pending: 0, approved: 1, rejected: 2 }

  extend FriendlyId
  friendly_id :name, use: :slugged
end
