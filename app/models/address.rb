class Address < ActiveRecord::Base
  belongs_to :organization

  validates :address, presence: true

  geocoded_by :address # can also be an IP address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

  delegate :title, :desc, to: :organization
end
