source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'

gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sassc-rails'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
# gem 'webpacker', '~> 4.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem 'socialization'

gem 'video_info'

gem 'sitemap_generator'

gem 'paper_trail'

gem 'exception_handler'

gem 'pagy'

gem 'faye'

gem 'roboto'

gem 'cocoon'

gem 'actionview-encoded_mail_to'

gem 'ancestry'
gem 'ransack'

gem 'nokogiri'

gem 'whenever', require: false

gem 'haml-rails'

gem 'addressable'

gem 'geocoder'

gem 'vkontakte_api'

gem 'devise'
gem 'devise-i18n'
gem 'cancancan'

gem 'omniauth-vkontakte'
gem 'friendly_id'

# gem 'gritter_notices'

gem 'paperclip'

gem 'rmagick'

gem 'ckeditor'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'acts_as_list'
gem 'acts_as_votable'

gem 'activevalidators'

gem 'premailer-rails'

gem 'russian'
gem 'i18n'

gem 'acts-as-taggable-on'
gem 'bootstrap_form', '~> 4.0'

gem 'meta-tags', require: 'meta_tags'

# for calendar events
gem 'watu_table_builder', require: 'table_builder'

gem 'truncate_html'

gem 'twitter-typeahead-rails'
gem 'momentjs-rails',                  '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'
gem 'jquery-ui-rails'
gem 'fancybox2-rails'
gem 'animate-rails'
gem 'select2-rails'

gem 'font_awesome5_rails'

gem 'papercrop'
gem 'record_tag_helper', '~> 1.0'

group :development, :test do
  gem 'rspec-rails'#, github: 'rspec/rspec-rails', branch: '4-0-maintenance'
  gem 'rails-controller-testing'
  gem 'factory_bot_rails'
  gem 'faker'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'bullet'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
