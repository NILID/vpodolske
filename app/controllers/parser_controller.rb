class ParserController < ApplicationController
  before_action :authenticate_user!

  require 'open-uri'
  require 'nokogiri'
  require 'addressable/uri'

  def news_tvkvarc
    source = "http://tvpodolsk.ru/news/"
    @page = Nokogiri::HTML(open(source.to_s))
  end

  def news_riamo
    source = "https://podolskriamo.ru/n651/novosti?l&page=1"
    @page = Nokogiri::HTML(open(source.to_s), nil, 'UTF-8')
  end

  def dkzio
    source = "http://www.dkzio.ru/afisha"
    @page = Nokogiri::HTML(open(source.to_s), nil, 'UTF-8')
  end


  def news_admin
    source = ("http://xn----8sbancyabljpnebm2aiit6frfsd.xn--p1ai/category/novosti/page/1/")
    @page = Nokogiri::HTML(open(source.to_s))
  end

  def karofilm
    date = params[:date] || DateTime.now.strftime('%d.%m.%Y')
    source = "https://karofilm.ru/theatres?id=15&date=#{date}"
    @page = Nokogiri::HTML(open(source.to_s))
  end

  def inpodolsk
    page = params[:page] || 1
    source = "http://inpodolsk.ru/novosti?page=#{page}"
    @page = Nokogiri::HTML(open(source.to_s))
  end

  def dkoctober
    @pages = []
    (1..1).to_a.each do |page|
      begin
        p = "http://dk-october.ru/category/%D0%B0%D1%84%D0%B8%D1%88%D0%B0/page/#{page}/"
        @pages << Nokogiri::HTML(open(p.to_s))
       rescue
         break
       end
     end
  end

  def druzhba
    @pages = []
    (1..1).to_a.each do |page|
      begin
        p = "http://dkvoronovo.ru/index.php/nashi-meropriyatiya?page=#{page}"
        @pages << Nokogiri::HTML(open(p.to_s))
       rescue
         break
       end
     end
  end


  def metal_lvov
    @page = Nokogiri::HTML(open('http://www.metallurg-dk.ru/afisha'))
  end


  def dklepse
    @pages = []
    (1..2).to_a.each do |page|
      begin
        p = "http://www.dklepse.ru/afisha-meropriyatiy?page=#{page}"
        @pages << Nokogiri::HTML(open(p.to_s))
      rescue
        break
      end
    end
  end

  def parktal
    @pages = []
    (1..2).to_a.each do |page|
      begin
        p = "http://www.podolskpark.ru/category/afisha/page/#{page}"
        @pages << Nokogiri::HTML(open(p.to_s))
      rescue
        break
      end
    end
  end


  def dkkarl
    @pages = []
    (1..2).to_a.each do |page|
      begin
        p = "http://kulturakm.ru/afisha?page=#{page}"
        @pages << Nokogiri::HTML(open(p.to_s))
      rescue
        break
      end
    end
  end

  def sherbinka
    @pages = []
    (1..1).to_a.each do |page|
      begin
        binding.pry
        url = '%D0%B4%D0%B2%D0%BE%D1%80%D0%B5%D1%86-%D0%BA%D1%83%D0%BB%D1%8C%D1%82%D1%83%D1%80%D1%8B.%D1%80%D1%84'
        p = "http://#{url}/page/#{page}/"
        @pages << Nokogiri::HTML(open(p.to_s))
      rescue
        break
      end
    end
  end

  def spravka
    @page = Nokogiri::HTML(open('http://podolsk.spravker.ru/'))
  end

  def podolsk
    @page = Nokogiri::HTML(open('http://www.podolsk.ru/catalog/'))
  end

  def metallv
    @page = Nokogiri::HTML(open('http://www.metallurg-dk.ru/afisha'), Encoding::UTF_8.to_s)
  end

  def molodezh
    @page = Nokogiri::HTML(open('http://www.dkmol.ru/playbill/'))
  end

  def dubrov
    @page = Nokogiri::HTML(open('http://dubrovici.ru/?action=poster'))
  end

  def podolsk_cat
    #url = 'http://www.podolsk.ru/catalog/category/yuridicheskie-uslugi/kollektorskie-uslugi/'
    url = 'http://www.podolsk.ru/catalog/category/avtomobili-perevozki/avtozapravochnyie-stantsii/'
    @page = Nokogiri::HTML(open(url))

    a = @page.at_css('ul.pagination').last_element_child.at_css('a').attr('href')
    int = /\d+\z/.match(a) ? /\d+\z/.match(a)[0].to_i : 1

    @urls = []
    @pages = []

    (1..int).to_a.each do |page|
      begin
        p = url + "/?page=#{page}"
        @urls << p
        @pages << Nokogiri::HTML(open(p.to_s))
      rescue
        break
      end
    end

  end

end
