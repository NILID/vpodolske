module CheckEnvironment
  extend ActiveSupport::Concern

  def in_production?
    Rails.env.production?
  end
end