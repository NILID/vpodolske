# Configure dkim globally (see above)
Dkim::domain      = 'vpodolske.com'
Dkim::selector    = 'mail'
Dkim::private_key = File.open("#{Rails.root}/config/dkim.private.key").read

Dkim::signable_headers = Dkim::DefaultHeaders - %w{Message-ID Resent-Message-ID Date Return-Path Bounces-To}

# This will sign all ActionMailer deliveries
ActionMailer::Base.register_interceptor(Dkim::Interceptor)