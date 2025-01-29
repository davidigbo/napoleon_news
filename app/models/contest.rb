class Contest < ApplicationRecord
    has_many :contestants, dependent: :destroy

    enum status: { pending: 0, active: 1, completed: 2 }

    validates :name, presence: true
end
