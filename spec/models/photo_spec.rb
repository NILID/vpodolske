require 'rails_helper'

RSpec.describe Photo, type: :model do

  let(:photo) { build_stubbed(:photo) }

  context 'should' do
    it 'have title' do
      photo.slide = nil
      expect(photo.valid?).to be false
      expect(photo.errors[:slide]).not_to be_empty
    end

    it 'have slide type with current types' do
      %w[image/jpg image/jpeg image/gif image/png image/pjpeg image/x-png].each do |type|
        photo.slide_content_type = type
        expect(photo.valid?).to be true
        expect(photo.errors[:slide]).to be_empty
      end
    end

    it 'have year' do
      photo.year = nil
      expect(photo.valid?).to be false
      expect(photo.errors[:year]).not_to be_empty
    end

    it 'have year not -1' do
      photo.year = -3
      expect(photo.valid?).to be false
      expect(photo.errors[:year]).not_to be_empty
    end

    it 'have year not less than 1900' do
      photo.year = 1899
      expect(photo.valid?).to be false
      expect(photo.errors[:year]).not_to be_empty
    end

    it 'have year more 1900' do
      photo.year = 1900
      expect(photo.valid?).to be true
      expect(photo.errors[:year]).to be_empty
    end

    it 'have year less than current year' do
      photo.year = 2900
      expect(photo.valid?).to be false
      expect(photo.errors[:year]).not_to be_empty
    end
  end
end
