class Block < ApplicationRecord
  belongs_to :page

  has_paper_trail on: %i[create update], ignore: %i[update_at position]

  validates :title, presence: true

  before_destroy do
    self.versions.destroy_all
  end
end
