require 'rails_helper'

describe Note do
  let(:note) { build_stubbed(:note) }

  context 'should' do
    it 'have content' do
      note.content = nil
      expect(note.valid?).to be false
      expect(note.errors[:content]).not_to be_empty
    end

    it 'have content not less 25 symbols' do
      note.content = 'k'*24
      expect(note.valid?).to be false
      expect(note.errors[:content]).not_to be_empty
    end

    it 'have content not more 2000 symbols' do
      note.content = 'k'*2001
      expect(note.valid?).to be false
      expect(note.errors[:content]).not_to be_empty
    end

    it 'have valid email' do
      note.email = 'emaildotcom'
      expect(note.valid?).to be false
      expect(note.errors[:email]).not_to be_empty
    end
  end
end
