require 'addressable/uri'
include ApplicationHelper

class Event < ActiveRecord::Base
  include CheckEnvironment

  attr_reader :src_remote_url
  belongs_to :user
  acts_as_votable
  before_save :current_url, if: Proc.new { |event| event.url?  }
  before_create :make_old_title
  # after_create :send_mail_admin, if: :in_production?

  has_attached_file :src,
    :styles      => { medium: '400x400', thumb: '280x280#' },
    :url         => '/system/events/:attachment/:id/:style_:get_title.:extension',
    :path        => ':rails_root/public/system/events/:attachment/:id/:style_:get_title.:extension',
    :default_url => '/missing/event_:style.jpg'

  geocoded_by :address   # can also be an IP address
  after_validation :geocode, if: ->(obj){ obj.address.present? and !obj.latitude.present? and !obj.longitude.present? }
  #, if: :address_changed?    # auto-fetch coordinates

  validates :title, :content, presence: true
  validates :eventdate, presence: true, unless: :hidden?
  validates :title,   length: { in: 3..100 }
  validates :content, length: { minimum: 5 }
  validates :siteurl, uniqueness: true, allow_nil: true

  validates_attachment :src, content_type: { content_type: %w[image/jpg image/jpeg image/gif image/png image/pjpeg image/x-png] }
  # TODO
  # validate url format
  # validate current start and end, not greated

  scope :coolest, -> { where(cool: true) }
  scope :shownen, -> { where(hidden: false) }
  scope :hidden, -> { where(hidden: true) }

  Paperclip.interpolates :get_title do |attachment, style|
    attachment.instance.old_title.parameterize + '_vpodolske'
  end

  def update_views!
    self.increment!(:views)
  end

  def desc
    content
  end

  def self.mass_parse
    make_parse
    make_parse_druzhba
    make_parse_lepse
    make_parse_molodezh
    make_parse_talal
    # make_parse_karl
    # get_events_from_vk!
  end

  # TODO
  # ADD CHECK TO NEW YEAR!!!!!!!!!!!!!

  #############################  DK OCTOBER

  def self.make_parse
    @pages = []
    (1..9).to_a.each do |page|
      begin
        p = "http://dk-october.ru/category/%d0%b0%d1%84%d0%b8%d1%88%d0%b0/page/#{page}"
        @pages << Nokogiri::HTML(open(p.to_s))
      rescue
        break
      end
    end

    @pages.each do |page|
      page.css('.article').each do |link|
        source = link.at_css('.btn').attr('href')
        new_event = Event.new(siteurl: source)
        new_event.valid?
        new_event.build_from_source(source, link) if new_event.errors[:siteurl].empty?
      end
    end
  end

  def build_from_source(source, link)
    p = Nokogiri::HTML(open(source.to_s))

    text = p.css('.page p')
    text.search('a, button').remove

    s_content = text

    date = p.at_css('.dateinfo').text.squish
    s_date= DateTime.strptime(russian_to_english_date(date), '%d %b / %H:%M')
    s_time = s_date.strftime('%H:%M')

    e = Event.new(title: p.at_css('.page h1').text,
              placename: I18n.t('places.dkoctober.title'),
                address: I18n.t('places.dkoctober.address'),
              eventdate: s_date,
                content: s_content,
               eventime: s_time,
                 hidden: false,
               latitude: I18n.t('places.dkoctober.lat'),
              longitude: I18n.t('places.dkoctober.lon'),
                siteurl: source)

   s_image = p.at_css('.wp-post-image')

   if s_image
      e.src_remote_url = s_image.attr('src')
   end

   e.save! if e.valid?
  end

  #############################  DK DRUZHBA

  def self.make_parse_druzhba
    @pages = []
    (1..9).to_a.each do |page|
      begin
        p = "http://dkvoronovo.ru/index.php/nashi-meropriyatiya?page=#{page}"
        @pages << Nokogiri::HTML(open(p.to_s))
      rescue
        break
      end
    end

    @pages.each do |page|
      page.css('#icagenda .ic-event').each do |link|
        source = 'http://dkvoronovo.ru' + link.at_css('.ic-content h2 a').attr('href')
        new_event = Event.new(siteurl: source)
        new_event.valid?
        new_event.build_from_source_druzhba(source, link) if new_event.errors[:siteurl].empty?
      end
    end
  end

  def build_from_source_druzhba(source, link)
    p = Nokogiri::HTML(open(source.to_s))

    s_title = link.at_css('.ic-content h2').text.squish
    s_content = s_title

    date = "#{link.at_css('.ic-day').text.squish} #{link.at_css('.ic-month').text.squish} #{link.at_css('.ic-year').text.squish}"
    #date = temp.search('a, span, img').remove
    s_date = DateTime.strptime(russian_to_english_date(date),'%d %b %Y')
    s_time = link.at_css('.ic-time').text.present? ? link.at_css('.ic-time').text.squish : nil

    e = Event.new(title: s_title,
              placename: I18n.t('places.druzhba.title'),
                address: I18n.t('places.druzhba.address'),
              eventdate: s_date,
                content: s_content,
               eventime: s_time,
                 hidden: false,
               latitude: I18n.t('places.druzhba.lat'),
              longitude: I18n.t('places.druzhba.lon'),
                siteurl: source)

   e.save! if e.valid?
  end


  #############################  LEPSE

  def self.make_parse_lepse
    @pages = []
    (1..9).to_a.each do |page|
      begin
        p = "http://www.dklepse.ru/afisha?page=#{page}"
        @pages << Nokogiri::HTML(open(p.to_s))
      rescue
        break
      end
    end

    @pages.each do |page|
      page.css('.ic-list-events .ic-event').each do |link|
        source = 'http://www.dklepse.ru' + link.at_css('h2 a').attr('href')
        new_event = Event.new(siteurl: source)
        new_event.valid?
        new_event.build_from_source_lepse(source, link) if new_event.errors[:siteurl].empty?
      end
    end
  end

  def build_from_source_lepse(source, link)
    p = Nokogiri::HTML(open(source.to_s))

    s_title   = link.at_css('.ic-content h2 a').text
    s_content = p.css('.ic-full-description').text.squish
    s_date    = russian_to_english_date(p.at_css('.ic-single-next').text.squish)
    s_time    = link.at_css('.ic-date .ic-time').text.squish

    e = Event.new(title: s_title,
              placename: I18n.t('places.dklepse.title'),
                address: I18n.t('places.dklepse.address'),
              eventdate: s_date,
                content: s_content,
               eventime: s_time,
               latitude: I18n.t('places.dklepse.lat'),
              longitude: I18n.t('places.dklepse.lon'),
                 hidden: false,
                siteurl: source)
    e.save! if e.valid?
  end

  #############################  MOLODEZH

  def self.make_parse_molodezh
    @page = Nokogiri::HTML(open('http://www.dkmol.ru/playbill/'))

    @page.css('.playbill-item').each do |link|
      if link.at_css('time')
        source = 'http://www.dkmol.ru/' + link.at_css('a').attr('href')
        new_event = Event.new(siteurl: source)
        new_event.valid?
        new_event.build_from_source_molodezh(source, link) if new_event.errors[:siteurl].empty?
      end
    end
  end

  def build_from_source_molodezh(source, link)
    p = Nokogiri::HTML(open(source.to_s))

    s_title   = p.at_css('.single-post h1').text
    s_content = p.at_css('.single-post h6').text

    date = p.at_css('time')
    s_date    = date.attr(:datetime)
    s_time    = /\d{2}:\d{2}/.match(date).to_s

    e = Event.new(title: s_title.squish,
              placename: I18n.t('places.molodezh.title'),
                address: I18n.t('places.molodezh.address'),
              eventdate: s_date,
                content: s_content,
               eventime: s_time,
               latitude: I18n.t('places.molodezh.lat'),
              longitude: I18n.t('places.molodezh.lon'),
                 hidden: false,
                siteurl: source)

    if p.at_css('.single-post img')
      e.src_remote_url = 'http://www.dkmol.ru/' + p.at_css('.single-post img').attr(:src)
    end

    e.save! if e.valid?
  end

  #############################  TALALIHINA

  def self.make_parse_talal
    @pages = []
    (1..1).to_a.each do |page|
      begin
        p = "http://www.podolskpark.ru/category/afisha/page/#{page}"
        @pages << Nokogiri::HTML(open(p.to_s))
      rescue
        break
      end
    end

    @pages.each do |page|
      page.css('article.post').each do |link|
        source = link.at_css('h5 a').attr('href')
        new_event = Event.new(siteurl: source)
        new_event.valid?
        new_event.build_from_source_talal(source, link) if new_event.errors[:siteurl].empty?
      end
    end
  end

  def build_from_source_talal(source, link)
    p = Nokogiri::HTML(open(source.to_s))

    temp = p.css('.post_text_inner p')
    content = temp.search('a, span, img').remove

    s_title   = link.at_css('h5 a').text
    s_content = content.inner_html
    s_image = p.at_css('.post_image img')

    e = Event.new(title: s_title,
              placename: I18n.t('places.talal.title'),
                address: I18n.t('places.talal.address'),
                content: s_content,
               latitude: I18n.t('places.talal.lat'),
              longitude: I18n.t('places.talal.lon'),
                siteurl: source)
   if s_image
      e.src_remote_url = s_image.attr('src')
   end

    e.save! if e.valid?
  end

  #############################  DK KARL

  def self.make_parse_karl
    @pages = []
    (1..3).to_a.each do |page|
      begin
        p = "http://kulturakm.ru/afisha?page=#{page}"
        @pages << Nokogiri::HTML(open(p.to_s))
      rescue
        break
      end
    end

    @pages.each do |page|
      page.css('#block-system-main .view-content .views-row').each do |link|
        source = 'http://kulturakm.ru' + link.at_css('.views-field-title .field-content a').attr('href')
        new_event = Event.new(siteurl: source)
        new_event.valid?
        new_event.build_from_source_karl(source, link) if new_event.errors[:siteurl].empty?
      end
    end
  end

  def build_from_source_karl(source, link)
    p = Nokogiri::HTML(open(source.to_s))

    s_title   = link.at_css('.views-field-title .field-content a').text.squish
    s_content = p.at_css('#block-system-main .field-name-body').text.squish
    if /\d{1,2} [а-яА-Я0-9]+ - \d{1,2} [а-яА-Я]+$/.match(s_title)
      reg = /\d{1,2} [а-яА-Я0-9]+ - \d{1,2} [а-яА-Я]+$/.match(s_title).to_s
      start_date  = reg.split('-').first.squish + "  #{DateTime.now.year}"
      finish_date = reg.split('-').last.squish + "  #{DateTime.now.year}"
      s_time = nil
      s_finish_date = DateTime.strptime(russian_to_english_date(finish_date), '%d %b %Y')
    elsif /\d{1,2} [а-яА-Я]+ \d{1,2}:\d{1,2}$/.match(s_title)
      date = /\d{1,2} [а-яА-Я]+ \d{1,2}:\d{1,2}$/.match(s_title).to_s
      start_date = /\d{1,2} [а-яА-Я]+/.match(date).to_s + "  #{DateTime.now.year}"
      s_time    = /\d{1,2}:\d{1,2}$/.match(date).to_s
      s_finish_date = nil
    end

    s_date = !start_date.nil? ? DateTime.strptime(russian_to_english_date(start_date), '%d %b %Y') : nil
    s_image = p.at_css('#block-system-main .field-name-body .colorbox img') || link.at_css('.views-field-field-slide img')

    e = Event.new(title: s_title,
              placename: I18n.t('places.dkkarl.title'),
                address: I18n.t('places.dkkarl.address'),
              eventdate: s_date,
             finishdate: s_finish_date,
                content: s_content,
               eventime: s_time,
               latitude: I18n.t('places.dkkarl.lat'),
              longitude: I18n.t('places.dkkarl.lon'),
         src_remote_url: s_image.attr('src'),
                 hidden: s_date ? false : true,
                siteurl: source)
    e.save! if e.valid?
  end

  #############################  DK KARO

  def self.make_parse_karofilm
    @pages = []
    dates = (DateTime.now .. DateTime.now + 14.days).to_a.map { |d| d.strftime('%d.%m.%Y') }
    dates.each do |page|
      begin
        p = "https://karofilm.ru/theatres?id=15&date=#{date}"
        @pages << Nokogiri::HTML(open(p.to_s))
      rescue
        break
      end
    end

    @pages.each do |page|
      page.css('.cinema-page-item__schedule__row').each do |link|
        source = link.at_css('h2 a').attr('href')
        img = link.at_css('img').attr('src')
        new_event = Event.new(siteurl: (source + img))
        new_event.valid?
        new_event.build_from_source_lepse(source, link, img) if new_event.errors[:siteurl].empty?
      end
    end
  end

  def build_from_source_karofilm(source, link, img)
    p = Nokogiri::HTML(open(source.to_s))

    s_title   = link.at_css('h3').text
    s_content = s_title
    s_date    = /\d{2}.\d{2}.\d{4}/.match(source)[0]
    s_time    = link.at_css('.ic-time').text.squish

    e = Event.new(title: s_title,
              placename: I18n.t('places.dklepse.title'),
                address: I18n.t('places.dklepse.address'),
              eventdate: s_date,
                content: s_content,
               eventime: s_time,
               latitude: I18n.t('places.dklepse.lat'),
              longitude: I18n.t('places.dklepse.lon'),
                 hidden: false,
         src_remote_url: img.gsub(/w108h165q100_r.jpg/, 'w407hq100.jpg'),
                siteurl: source)
    e.save! if e.valid?
  end

  #######################  END PARSE

  #############################  VKONTAKTE
  def self.get_events_from_vk!
    u = User.find(45)
    vk_client = VkontakteApi::Client.new(u.auth_raw_info)

    vk_events = vk_client.groups.search(q: ' ', type: 'event', city_id: 270, future: 1, count: 200, fields: 'place,start_date,finish_date,description,cover').items
    vk_events.each do |vk_event|
      event = vk_event

      siteurl = "https://vk.com/groups/#{vk_event.id}" # uniq

      s_title = event.name
      if event.place
        s_placename = event.place.title
        s_address = event.place.address
        s_lat = event.place.latitude
        s_long = event.place.longitude
      else
        s_placename = nil
        s_address = nil
        s_lat = nil
        s_long = nil
      end
      s_start_date  = event.start_date ? Time.at(event.start_date) : nil
      s_time        = event.start_date ? Time.at(event.start_date).strftime('%H:%M') : nil
      s_finish_date = event.finish_date ? Time.at(event.finish_date) : nil
      s_finish_time = event.finish_date ? Time.at(event.finish_date).strftime('%H:%M') : nil
      s_content = event.description
      if event.cover.enabled == 1
        s_image = event.cover.images.last.url
      else
        s_image = event.photo_200
      end
      s_url = "https://vk.com/" + event.screen_name

      e = Event.new(title: s_title,
                placename: s_placename,
                  address: s_address,
                eventdate: s_start_date,
                  content: s_content,
                 eventime: s_time,
               finishdate: s_finish_date,
               finishtime: s_finish_time,
                 latitude: s_lat,
                longitude: s_long,
                   hidden: true, # to false
           src_remote_url: s_image,
                  siteurl: siteurl,
                      url: s_url)
      e.save! if e.valid?
    end
  end
  #########################


  def to_param
    "#{id}-#{title.parameterize}"
  end

  def set_cool
    self.update_attribute(:cool, !self.cool)
  end

  def src_remote_url=(url_value)
    encoding_url = URI.encode(url_value)
    self.src = URI.parse(encoding_url).open
    @src_remote_url = encoding_url
  end

  def current_url
    a = self.url.gsub('http://', '')
    a = a.gsub('https://', '')
    self.url=a
  end

  private

  def make_old_title
    self.old_title = self.title
  end

  def send_mail_admin
    User.admins.each { |admin| NotificationMailer.check_item(admin).deliver_now } # if !self.user  || (self.user != admin)
  end
end
