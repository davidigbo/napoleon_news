class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # has_many :user_roles, dependent: :destroy
  # has_many :role, through: :user_roles
  has_many :authored_articles, foreign_key: "author_id", class_name: "Article", dependent: :destroy
  has_many :approved_articles, foreign_key: "approved_by_id", class_name: "Article"


  validates :email, presence: true

  enum :role, [:visitor, :author, :editor, :admin]
end
