include ApplicationHelper
require 'openssl'

class Article < ActiveRecord::Base
  # has_paper_trail on: [:update]#, only: [:title]

  validates :title, presence: true
  validates :url, uniqueness: true, allow_nil: true

  PROVIDERS = %w[kvarc riamo podolsk_admin]

  def to_param
    "#{id}-#{title.parameterize}"
  end

  ransacker :casetitle, formatter: proc { |v| v.mb_chars.upcase.to_s } do |parent|
    Arel::Nodes::NamedFunction.new('UPPER',[parent.table[:title]])
  end

  def self.mass_parse
    make_parse
    make_parse_admin
    make_parse_riamo
  end

  # tvkvarc

  def self.make_parse
    @page = Nokogiri::HTML(open('http://tvpodolsk.ru/news/?sort=date&page=1'))

    @page.search('.main, .last').remove

    @page.css('.page-our-people .article').each do |link|
      source = 'http://tvpodolsk.ru' + link.at_css('a').attr('href')
      new_article = Article.new(url: source)
      new_article.valid?
      new_article.build_from_source(source, link)# if new_article.errors[:url].empty?
    end
  end

  def build_from_source(source, link)
    s_title = link.at_css('.title').text.squish

    date = link.at_css('.date').text.squish
    s_date = DateTime.strptime(russian_to_english_date(date),'%d %b %Y')

    e = Article.new(title: s_title,
                  from_at: s_date,
                      url: source,
                 provider: 'kvarc'
                      )
    e.save! if e.valid?
  end

  # riamo

  def self.make_parse_riamo
    # OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

    source = "https://podolskriamo.ru/n651/novosti?l&page=1"
    @page = Nokogiri::HTML(open(source.to_s, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}), nil, 'UTF-8')

    @page.css('.content-container .news-item').each do |link|
      source = 'https://podolskriamo.ru' + link.at_css('a').attr('href')
      new_article = Article.new(url: source)
      new_article.valid?
      new_article.build_from_source_riamo(source, link) # if new_article.errors[:url].empty?
    end
  end

  def build_from_source_riamo(source, link)
    s_title = link.at_css('h2').text.squish

    date = link.at_css('time').text.squish
    s_date = DateTime.strptime(russian_to_english_date(date),'%d %b %Y, %H:%M')

    e = Article.new(title: s_title,
                  from_at: s_date,
                      url: source,
                 provider: 'riamo'
                )
    e.save! if e.valid?
  end


  # podolsk admin

  def self.make_parse_admin
    source = ("http://xn----8sbancyabljpnebm2aiit6frfsd.xn--p1ai/category/novosti/page/1/")
    @page = Nokogiri::HTML(open(source.to_s))

    @page.css('.td-main-content .item-details').each do |link|
      source = link.at_css('h3 a').attr('href')
      new_article = Article.new(url: source)
      new_article.valid?
      new_article.build_from_source_admin(source, link)# if new_article.errors[:url].empty?
    end
  end

  def build_from_source_admin(source, link)
    s_title = link.at_css('h3').text.squish
    s_date = link.at_css('time').attr('datetime')

    e = Article.new(title: s_title,
                  from_at: s_date,
                      url: source,
                 provider: 'podolsk_admin'
                )
    e.save! if e.valid?
  end
end
