class Profile < ActiveRecord::Base
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  belongs_to :user
  has_attached_file :avatar,
         :styles => { thumb: '50x50#', large: '600x600>', medium: '200x200#' },
         :default_url => '/custom/avatars/:style/missing:what_gender.png',
         :url  => '/system/:attachment/:id/:style_:filename',
         :path => ':rails_root/public/system/:attachment/:id/:style_:filename'
  crop_attached_file :avatar

  validates_attachment :avatar, content_type: { content_type: %w[image/jpg image/jpeg image/gif image/png image/pjpeg image/x-png] }

  validates :aboutme, length: { in: 5..300 }, allow_blank: true

  GENDERS = [[I18n.t(:male), 'm'], [I18n.t(:female), 'f']]

  Paperclip.interpolates :what_gender do |attachment, style|
    attachment.instance.what_gender.parameterize
  end

  def what_gender
    self.gender == 'f' ? '_f' : '_m'
  end
end
