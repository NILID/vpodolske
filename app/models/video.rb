class Video < ActiveRecord::Base
  belongs_to :user

  acts_as_likeable
  acts_as_taggable_on :keywords

  validates :title, presence: true
  validates :url, uniqueness: true, presence: true, format: { with: URI.regexp(%w(http https)), message: I18n.t('videos.must_have_http') }
  validates :url, format: { with: /(youtu.be|youtube.com\/watch\?(?=[^?]*v=\w+)(?:[^\s?]*)$)/, message: I18n.t('videos.must_have_youtube') }

  has_many :comments, :as => :commentable

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def update_views(by = 1)
    self.views ||= 0
    self.views += by
    self.save
  end
end
