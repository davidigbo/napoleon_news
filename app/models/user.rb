class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # has_many :user_roles, dependent: :destroy
  # has_many :role, through: :user_roles
  has_many :authored_articles, foreign_key: "author_id", class_name: "Article", dependent: :destroy
  has_many :approved_articles, foreign_key: "approved_by_id", class_name: "Article"
  has_many :quizzes, dependent: :destroy
  has_many :responses, dependent: :destroy

  has_one_attached :profile_picture
  
  has_many :votes, foreign_key: 'voter_id'

  validates :email, presence: true
  scope :authors, -> { where(role: ['author', 'admin', 'editor']) }


  enum :role, [:visitor, :author, :editor, :admin]

  def active_for_authentication?
    super && active?
  end

  def name
    "#{first_name} #{last_name}"
  end

  def active?
    self.active
  end

  def voted?(contest)
    votes.exists?(contest: contest)
  end
end
