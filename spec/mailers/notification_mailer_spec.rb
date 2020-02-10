require 'rails_helper'

describe NotificationMailer do

  let(:organization) { create(:organization) }
  let(:from_email)   { 'info@vpodolske.com' }
  let(:user)         { create(:user) }

  describe('for different users') do
    after(:each) do
      # expect(ActionMailer::Base.deliveries).not_to be_empty
      expect(@email.from).to eq([from_email])
      expect(@email.encoded).not_to be_nil
    end

    it 'inivitation for reg user notification should be delivered' do
      @email = NotificationMailer.accept_organization(organization)
      expect(@email.subject).to eq(I18n.t('mailer.accept_organization'))
      expect(organization.user_id?).to be true
      expect(@email.to).to eq([organization.user.email])
    end

    it 'provide access organization gor reg user notification should be delivered' do
      @email = NotificationMailer.provide_access_organization(organization)
      expect(@email.subject).to eq(I18n.t('mailer.provide_access_organization'))
      expect(@email.to).to eq([organization.user.email])
    end

    it 'inivitation for unreg user notification should be delivered' do
      @organization = create(:organization, :without_user)
      @email = NotificationMailer.accept_organization(@organization)
      expect(@email.subject).to eq(I18n.t('mailer.accept_organization'))
      expect(@organization.user_id?).to be false
      expect(@email.to).to eq([@organization.email])
    end
  end
end
