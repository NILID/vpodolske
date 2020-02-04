class Category < ActiveRecord::Base
  belongs_to :categorable, polymorphic: true
  has_and_belongs_to_many :organizations
  has_ancestry

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  validates :title, uniqueness: true, presence: true

  def self.parse!
    @page = Nokogiri::HTML(open(Rails.application.credentials.categories_donor))
    @page.css('.container_left .row-spaced .media').each do |link|
      root_link = link.at_css('h4 a')
      root_title = root_link.text.squish

      root_cat = where(title: root_title).first
      unless root_cat
        root_cat = create!(title: root_title)
      end

      url = root_link.attr('href')
      categories_url = Nokogiri::HTML(open(url))
      categories_url.css('.container_left .media .media-heading').each do |l|
        cat_title = l.text.squish
        child_cat = where(title: cat_title).first
        unless child_cat
          create!(title: cat_title, parent_id: root_cat.id, url: l.at_css('a').attr('href'))
        end
      end
    end
  end

  def make_organizations_count
    update_attribute(:organizations_count, organizations.pluck(:id).count)
  end

  ransacker :casetitle, formatter: proc { |v| v.mb_chars.upcase.to_s } do |parent|
    Arel::Nodes::NamedFunction.new('UPPER',[parent.table[:title]])
  end

  def self.ids_from_tokens(tokens)
    tokens.select{ |i| i[/<<<(.+?)>>>/] }.each do |t|
      token = create!(title: $1)
      tokens[tokens.index(t)] = token.id
    end
    tokens
  end
end
