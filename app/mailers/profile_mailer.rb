class ProfileMailer < ApplicationMailer
  def settings(user)
    @user = user
    mail(:to => "#{user.login} <#{user.email}>", subject: 'Registered')
  end
end