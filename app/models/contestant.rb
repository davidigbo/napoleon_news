class Contestant < ApplicationRecord
  extend FriendlyId
  # include Discard::Model
  # default_scope -> { kept }
  
  belongs_to :user
  belongs_to :contest
  belongs_to :approved_by, class_name: 'User', optional: true
  has_one_attached :image
  has_many :votes

  validates :description, presence: true
  validates :user, uniqueness: { scope: :contest }
  # validates :image, content_type: [:png, :jpg, :jpeg]
  # validates :image, content_type: ['image/png', 'image/jpg', 'image/jpeg']


  enum approved: { pending: 0, approved: 1, rejected: 2 }

  friendly_id :stage_name, use: :slugged

  after_create :send_new_contest_notification
  after_update :send_approval_notification, if: :saved_change_to_approved?

  private

  # def set_approved_at
  #   self.approved_at = Time.current if approved === "approved" && approved_at.nil?
  #   self.approved_by_id = user.id if approved === "approved" && approved_by_id.nil?
  # end

  def send_new_contest_notification
    ContestMailer.new_contestant_mail(user).deliver_later
  end

  def send_approval_notification
      case approved
      when "approved"
        ContestMailer.approve_contestant_mail(user).deliver_later
      when "rejected"
        ContestMailer.reject_contestant_mail(user).deliver_later
      end
  end
end
