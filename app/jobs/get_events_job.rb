class GetEventsJob < ActiveJob::Base
  queue_as :default

  def perform
    Event.mass_parse
  end
end
