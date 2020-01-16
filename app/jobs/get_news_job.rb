class GetNewsJob < ActiveJob::Base
  queue_as :default

  def perform
    Article.mass_parse
  end
end
