require 'rails_helper'

RSpec.describe Place, type: :model do

  let(:place) { build(:place) }

  context 'should' do
    it 'have title' do
      place.title = nil
      expect(place.valid?).to be false
      expect(place.errors[:title]).not_to be_empty
    end
  end
end
