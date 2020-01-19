require 'rails_helper'

RSpec.describe Category, type: :model do

  let(:category) { build_stubbed(:category) }

  context 'should' do
    it 'have title' do
      category.title = nil
      expect(category.valid?).to be false
      expect(category.errors[:title]).not_to be_empty
    end
  end
end
