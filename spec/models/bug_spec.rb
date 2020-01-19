require 'rails_helper'

RSpec.describe Bug, type: :model do

  let(:bug) { build_stubbed(:bug) }

  context 'should' do
    it 'have content' do
      bug.content = nil
      expect(bug.valid?).to be false
      expect(bug.errors[:content]).not_to be_empty
    end

    it 'have content more than 10' do
      bug.content = 'one two'
      expect(bug.valid?).to be false
      expect(bug.errors[:content]).not_to be_empty

      bug.content = 'one two three four'
      expect(bug.valid?).to be true
      expect(bug.errors[:content]).to be_empty
    end
  end
end
