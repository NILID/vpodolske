class Page < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  has_many :blocks

  validates :title, uniqueness: true, presence: true, length: { minimum: 2 }
end
