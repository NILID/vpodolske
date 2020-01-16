require 'vkontakte_api'

VkontakteApi.configure do |c|
  c.log_requests = false
  c.api_version  = '5.74'
  c.app_id       = Rails.application.credentials.vk_app_id
  c.app_secret   = Rails.application.credentials.vk_app_secret
end
