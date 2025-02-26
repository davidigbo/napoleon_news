class PageView < ApplicationRecord
  belongs_to :user, optional: true
end
