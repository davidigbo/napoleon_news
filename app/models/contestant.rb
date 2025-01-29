class Contestant < ApplicationRecord
  belongs_to :user
  belongs_to :contest
  belongs_to :approved_by, class_name: 'User', optional: true

  has_one_attached :image

  has_one_attached :description

  validates :description, presence: true
  validates :image, content_type: [:png, :jpg, :jpeg]

  enum approved: { pending: 0, approved: 1, rejected: 2 }

  extend FriendlyId
  friendly_id :name, use: :slugged

  before_update :set_approved_at, if: :approved_changed?

  private

  def set_approved_at
    self.approved_at = Time.current if approved === "approved" && approved_at.nil?
    self.approved_by_id = user.id if approved === "approved" && approved_by_id.nil?
  end
end
