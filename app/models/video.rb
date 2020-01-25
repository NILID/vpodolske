class Video < ActiveRecord::Base
  belongs_to :user
  has_many :comments, as: :commentable

  acts_as_likeable
  acts_as_taggable_on :keywords

  validates :title, :url, presence: true
  validates :url, presence: true,
                    format: { with: /\A(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+\z/ }

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def update_views(by = 1)
    self.views ||= 0
    self.views += by
    self.save
  end
end
