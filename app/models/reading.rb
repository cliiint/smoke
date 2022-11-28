class Reading < ApplicationRecord
  validates :aqi, presence: true, comparison: { greater_than_or_equal_to: 0 }

  belongs_to :user
end
