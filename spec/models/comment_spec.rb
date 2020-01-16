require 'rails_helper'

RSpec.describe Comment, type: :model do

  let(:comment) { build(:comment) }

  context 'should' do
    it 'have content' do
      comment.content = nil
      expect(comment.valid?).to be false
      expect(comment.errors[:content]).not_to be_empty
    end

    it 'have content not less 5 symbols' do
      comment.content = 'k'*4
      expect(comment.valid?).to be false
      expect(comment.errors[:content]).not_to be_empty
    end
  end
end
