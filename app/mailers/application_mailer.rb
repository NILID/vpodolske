class ApplicationMailer < ActionMailer::Base
  default from: 'info@vpodolske.com'
  layout 'notification_mailer'
end
