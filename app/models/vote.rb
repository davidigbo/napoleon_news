class Vote < ApplicationRecord
  belongs_to :contestant
  belongs_to :voter, class_name: 'User'
end
