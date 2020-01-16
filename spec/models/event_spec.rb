require 'rails_helper'

describe Event do
  let(:event) { build(:event, :soon) }

  context 'should' do
    it 'have title' do
      event.title = nil
      expect(event.valid?).to be false
      expect(event.errors[:title]).not_to be_empty
    end

    it 'have old_title after save' do
      expect(event.old_title).to be_nil
      event.save!
      expect(event.old_title).not_to be_nil
      expect(event.title).to eq(event.old_title)
    end

    it 'have title not less 3 symbols' do
      event.title = 'ku'
      expect(event.valid?).to be false
      expect(event.errors[:title]).not_to be_empty
    end

    it 'have title not more 100 symbols' do
      event.title = 'ku' * 51
      expect(event.valid?).to be false
      expect(event.errors[:title]).not_to be_empty
    end

    it 'have content' do
      event.content = nil
      expect(event.valid?).to be false
      expect(event.errors[:content]).not_to be_empty
    end

    it 'have content not less 5 symbols' do
      event.content = 'k'*4
      expect(event.valid?).to be false
      expect(event.errors[:content]).not_to be_empty
    end

    it 'have eventdate if hidden?' do
      event.eventdate = nil
      expect(event.hidden?).to be true
      expect(event.valid?).to be true
      expect(event.errors[:eventdate]).to be_empty
    end

    it 'have eventdate if unhidden?' do
      event.eventdate = nil
      event.hidden = false
      expect(event.valid?).to be false
      expect(event.errors[:eventdate]).not_to be_empty
    end

    it 'have src type with current types' do
      %w[image/jpg image/jpeg image/gif image/png image/pjpeg image/x-png].each do |type|
        event.src_content_type = type
        expect(event.valid?).to be true
        expect(event.errors[:src]).to be_empty
      end
    end

    it 'have current url' do
      event.url = 'https://google.com'
      expect(event.current_url).to eq('google.com')
    end

    it 'have not unique siteurl' do
      event.save!
      new_event = build(:event)
      new_event.siteurl = event.siteurl
      expect(new_event.valid?).to be false
      expect(new_event.errors[:siteurl]).not_to be_empty
    end

    it 'show update views' do
      expect{ event.update_views! }.to change{ event.views }.by(1)
    end
  end
end
