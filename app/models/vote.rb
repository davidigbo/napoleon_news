class Vote < ApplicationRecord
  belongs_to :contestant
  belongs_to :voter, class_name: 'User', foreign_key: 'voter_id'
  belongs_to :contest
end
