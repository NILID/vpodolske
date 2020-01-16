class NotificationMailer < ApplicationMailer
  include ApplicationHelper

  def check_item(admin)
    @admin = admin
    mail(to: admin.email, subject: I18n.t('mailer.check_item'), template_name: 'check_item')
  end

  def send_admin_letter(email, content)
    @content = content
    mail(to: email, subject: I18n.t('mailer.send_admin_letter'), template_name: 'admin_letter')
  end

  def accept_organization(organization)
    @organization = organization

    if organization.email || (organization.user && organization.user.email)
      if organization.user && organization.user.email
        @user = organization.user
        email = @user.email
      else
        email = organization.email
      end

      mail(to: email, subject: I18n.t('mailer.accept_organization'), template_name: 'accept_organization')
    end
  end
end