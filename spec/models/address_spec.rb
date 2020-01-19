require 'rails_helper'

RSpec.describe Address, type: :model do

  let(:address) { build_stubbed(:address) }

  context 'should' do
    it 'have address' do
      address.address = nil
      expect(address.valid?).to be false
      expect(address.errors[:address]).not_to be_empty
    end
  end
end
