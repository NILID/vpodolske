class Letter < ApplicationRecord
  after_create :send_mail_admin

  validates :content, :email, presence: true
  validates :email, email: true

  private

  def send_mail_admin
    NotificationMailer.send_admin_letter(self.email, self.content).deliver_now
  end
end
