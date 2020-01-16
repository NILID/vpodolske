class Place < ActiveRecord::Base
  belongs_to :user
  has_many :photos

  acts_as_votable

  validates :title, presence: true

  accepts_nested_attributes_for :photos, reject_if: :all_blank, allow_destroy: true

  def to_param
    "#{id}-#{title.parameterize}"
  end

  geocoded_by :address # can also be an IP address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

  def desc
    content
  end

end
