class MailPreview < ActionMailer::Preview
  def check_item
    NotificationMailer.check_item(User.first)
  end

  def send_admin_letter
    NotificationMailer.send_admin_letter('dm.ilin@mail.ru', 'Hello my name is')
  end


  def accept_organization
    organization = Organization.first
    NotificationMailer.accept_organization(organization)
  end
end
