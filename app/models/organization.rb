class Organization < ActiveRecord::Base
  before_create :make_old_title
  after_create :make_count
  after_destroy :remake_count

  belongs_to :user
  has_many :addresses, dependent: :destroy, inverse_of: :organization
  has_many :comments, as: :commentable
  has_and_belongs_to_many :categories
  has_attached_file :logo,
    :styles      => { medium: '400x400', thumb: '280x280#' },
    :url         => '/system/organizations/:attachment/:id/:style_:get_title.:extension',
    :path        => ':rails_root/public/system/organizations/:attachment/:id/:style_:get_title.:extension',
    :default_url => '/missing/organization_:style.jpg'
  accepts_nested_attributes_for :addresses, reject_if: :all_blank, allow_destroy: true

  STATUSES = %w[hidden shown blocked]

  # geocoded_by :address   # can also be an IP address
  # after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  #, if: :address_changed?    # auto-fetch coordinates
  #, if: ->(obj){ obj.address.present? and !obj.latitude.present? and !obj.longitude.present? }
  #, if: :address_changed?    # auto-fetch coordinates

  validates :title, :category_tokens, :status_mask, presence: true
  validates :email, email: true, allow_blank: true
  validates_attachment :logo, content_type: { content_type: %w[ image/jpg image/jpeg image/gif image/png image/pjpeg image/x-png image/svg+xml ] }
  validates :url, uniqueness: true, allow_nil: true
  validates :site, url: true, allow_blank: true

  scope :shown,   -> { with_status(:shown) }
  scope :hidden,  -> { with_status(:hidden) }
  scope :blocked, -> { with_status(:blocked) }

  attr_reader :category_tokens

  def category_tokens=(tokens)
    self.category_ids = Category.ids_from_tokens(tokens)
  end

  def send_accept_notification
    # Проверить отправку писем организации без юзера и email
    # Не выставлять флаг отправки
    NotificationMailer.accept_organization(self).deliver_now
  end

  def category_tokens
    category_ids
  end

  def update_views!
    self.increment!(:views)
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def statuses=(statuses)
    self.status_mask = (statuses & STATUSES).map { |r| 2**STATUSES.index(r) }.sum
  end

  def statuses
    STATUSES.reject { |r| ((status_mask || 0) & 2**STATUSES.index(r)).zero? }
  end

  def self.with_status(status)
    where('status_mask & ? > 0', 2**STATUSES.index(status.to_s))
  end

  def status?(status)
    statuses.include? status.to_s
  end

  def shown?
    statuses.include? 'shown'
  end

  def blocked?
    statuses.include? 'blocked'
  end


  def self.shown?
    statuses.include? 'shown'
  end


  def logo_remote_url=(url_value)
    encoding_url = URI.encode(url_value)
    self.logo = URI.parse(encoding_url).open
    @logo_remote_url = encoding_url
  end

  ransacker :casetitle, formatter: proc { |v| v.mb_chars.upcase.to_s } do |parent|
    Arel::Nodes::NamedFunction.new('UPPER',[parent.table[:title]])
  end

  Paperclip.interpolates :get_title do |attachment, style|
    attachment.instance.old_title.parameterize + '_vpodolske'
  end

  def make_count
    categories.each { |c| Category.increment_counter(:organizations_count, c.id) }
  end

  def remake_count
    categories.each { |c| Category.decrement_counter(:organizations_count, c.id) }
  end

  def self.make_parse(category)
    url = category.url
    puts "======== #{url} ==========="

    pages = []
    last_page = Organization.get_page_numbers(url)
    (1..last_page).to_a.each do |page|
      begin
        p = url + "/?page=#{page}"
        pages << Nokogiri::HTML(open(p.to_s))
      rescue
        break
      end
    end

    pages.each do |page|
      page.css('.container_left .panel .panel-body').each do |link|
        source = URI.encode(link.at_css('h4 a').attr('href'))
        new_organization = Organization.new(url: source)
        new_organization.valid?
        if new_organization.errors[:url].empty?
          new_organization.build_from_source(source, link, category)
        else
          org = Organization.where(url: source).first
          if org && (org.categories.exclude? category)
            org.categories << category
            org.save!
            Category.increment_counter(:organizations_count, category.id)
          end
        end
      end
    end
  end

  def self.get_page_numbers(url)
    # get last pagination page number
    page = Nokogiri::HTML(open(url))
    pagination_url = page.at_css('ul.pagination').last_element_child.at_css('a').attr('href')
    int = /\d+\z/.match(pagination_url) ? /\d+\z/.match(pagination_url)[0].to_i : 1
  end

  def build_from_source(source, link, category)
    p = Nokogiri::HTML(open(source.to_s))

    logo     = p.at_css('.container_left img[itemprop="logo"]')
    lat      = p.at_css('.container_left span[itemprop="latitude"]')
    long     = p.at_css('.container_left span[itemprop="longitude"]')
    desc     = p.at_css('.container_left div[itemprop="description"]')
    address  = p.at_css('.container_left div[itemprop="address"]')
    postal   = p.at_css('.container_left div[itemprop="postalCode"]')
    region   = p.at_css('.container_left div[itemprop="addressRegion"]')
    locality = p.at_css('.container_left div[itemprop="addressLocality"]')
    street   = p.at_css('.container_left div[itemprop="streetAddress"]')
    office   = p.at_css('.container_left div[itemprop="postOfficeBoxNumber"]')
    opening  = p.at_css('.container_left div[itemprop="openingHoursSpecification"]')
    phone    = p.at_css('.container_left span[itemprop="telephone"]')
    site     = p.at_css('.container_left #listing_www')

    o = Organization.new(
                   title: link.at_css('h4 a').text.squish,
                    desc: desc ? desc.inner_html : nil,
             postal_code: postal ? postal.text : nil,
          address_region: region ? region.text : nil,
        address_locality: locality ? locality.text : nil,
          street_address: street ? street.text : nil,
                  office: office ? office.text : nil,
                     url: source,
                worktime: opening ? opening.text.squish : nil,
                   phone: phone ? phone.text : nil,
                    site: site ? site.attr('href') : nil)

   if logo
     o.logo_remote_url = logo.attr('src')
   end

   if address && lat && long
     o.addresses.new(longitude: long.attr('content'), latitude: lat.attr('content'), address: address.text.squish)
   end

   o.categories = [category]

   o.save! if o.valid?

   category.update_attribute(:check, true)
  end

  private
    def make_old_title
      self.old_title = self.title
    end
end
