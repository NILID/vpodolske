require 'rails_helper'

describe Profile do
  let(:profile) { build(:profile) }
  context('should') do
    it 'have aboutme no more 300' do
      profile.aboutme = 'About' * 61
      expect(profile.valid?).to be false
      expect(profile.errors[:aboutme]).not_to be_empty
    end

    it 'have aboutme not less 5' do
      profile.aboutme = 'Me'
      expect(profile.valid?).to be false
      expect(profile.errors[:aboutme]).not_to be_empty
    end

    it 'have aboutme be empty' do
      profile.aboutme = nil
      expect(profile.valid?).to be true
      expect(profile.errors[:aboutme]).to be_empty
    end

    it 'have avatar type with current types' do
      %w[image/jpg image/jpeg image/gif image/png image/pjpeg image/x-png].each do |type|
        profile.avatar_content_type = type
        expect(profile.valid?).to be true
        expect(profile.errors[:avatar]).to be_empty
      end
    end

    it 'have avatar type with uncurrent types' do
      %w[word/pdf].each do |type|
        profile.avatar_content_type = type
        expect(profile.valid?).to be false
        expect(profile.errors[:avatar]).not_to be_empty
      end
    end
  end
end
