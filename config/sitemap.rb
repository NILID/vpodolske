# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://vpodolske.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  add events_path, :priority => 0.9, :changefreq => 'daily'
  add places_path, :priority => 0.9, :changefreq => 'weekly'
  add categories_path, :priority => 0.6, :changefreq => 'daily'
  add articles_path, :priority => 0.5, :changefreq => 'daily'
  add archive_events_path, :priority => 0.5, :changefreq => 'daily'

  Event.shownen.find_each do |event|
    add event_path(event), :lastmod => event.updated_at
  end

  Category.find_each do |c|
    add category_path(c)
  end

  Organization.shown.find_each do |o|
    add organization_path(o), :lastmod => o.updated_at
  end

  Place.find_each do |p|
    add place_path(p), :lastmod => p.updated_at
  end

end
