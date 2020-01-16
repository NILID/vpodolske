require 'rails_helper'

describe Letter do
  let(:letter) { build(:letter) }

  context 'should' do
    it 'have content' do
      letter.content = nil
      expect(letter.valid?).to be false
      expect(letter.errors[:content]).not_to be_empty
    end

    it 'have email' do
      letter.email = nil
      expect(letter.valid?).to be false
      expect(letter.errors[:email]).not_to be_empty
    end

    it 'have valid email' do
      letter.email = 'emaildotcom'
      expect(letter.valid?).to be false
      expect(letter.errors[:email]).not_to be_empty
    end
  end
end
