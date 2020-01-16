require 'rails_helper'

RSpec.describe Organization, type: :model do

  let(:organization) { build(:organization) }

  context 'should' do
    it 'have title' do
      organization.title = nil
      expect(organization.valid?).to be false
      expect(organization.errors[:title]).not_to be_empty
    end

    it 'have status' do
      organization.status_mask = nil
      expect(organization.valid?).to be false
      expect(organization.errors[:status_mask]).not_to be_empty
    end

    it 'have category' do
      organization.category_tokens = [""]
      expect(organization.valid?).to be false
      expect(organization.errors[:category_tokens]).not_to be_empty
    end

    it 'have uniq url' do
      organization.save!
      new_organization = build(:organization, url: organization.url)
      expect(new_organization.valid?).to be false
      expect(new_organization.errors[:url]).not_to be_empty
    end

    it 'have valid url' do
      organization.site = 'site url'
      expect(organization.valid?).to be false
      expect(organization.errors[:site]).not_to be_empty
    end

    it 'have prefix in site' do
      organization.site = 'google.ru'
      expect(organization.valid?).to be false
      expect(organization.errors[:site]).not_to be_empty
    end

    it 'have valid with good site' do
      organization.site = 'https://google.ru'
      expect(organization.valid?).to be true
      expect(organization.errors).to be_empty
    end


    it 'have empty url' do
      new_organization = build(:organization, url: '')
      expect(new_organization.valid?).to be true
      expect(new_organization.errors[:url]).to be_empty
    end

    it 'have old_title after save' do
      expect(organization.old_title).to be_nil
      organization.save!
      expect(organization.old_title).not_to be_nil
      expect(organization.title).to eq(organization.old_title)
    end

    it 'show update views' do
      expect{ organization.update_views! }.to change{ organization.views }.by(1)
    end

    it 'have valid email' do
      organization.email = 'emaildotcom'
      expect(organization.valid?).to be false
      expect(organization.errors[:email]).not_to be_empty
    end
  end
end
