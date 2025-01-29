class Vote < ApplicationRecord
  belongs_to :contestant
  belongs_to :voter
end
