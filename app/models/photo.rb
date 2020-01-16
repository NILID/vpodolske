class Photo < ActiveRecord::Base
  belongs_to :place
  belongs_to :user

  has_attached_file :slide,
      :styles      => { medium: '400x400>', thumb: '280x280#' },
      :url         => '/system/photos/:attachment/:id/:style_:filename.:extension',
      :path        => ':rails_root/public/system/photos/:attachment/:id/:style_:filename.:extension',
      :default_url => '/missing/event_:style.jpg'

  validates :year, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1900, less_than_or_equal_to: DateTime.now.year }

  validates_attachment :slide, presence: true
  validates_attachment_content_type :slide, :content_type => [ 'image/jpg', 'image/jpeg', 'image/gif', 'image/png' , 'image/pjpeg', 'image/x-png' ]
end
