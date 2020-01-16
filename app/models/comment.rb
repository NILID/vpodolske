class Comment < ActiveRecord::Base
  after_create :make_shown

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_ancestry

  validates :content, presence: true, length: { minimum: 5 }

  scope :shown, -> { where(hidden: false) }

  private

  def make_shown
    if self.user
      self.update_attribute(:hidden, false)
    end
  end
end
