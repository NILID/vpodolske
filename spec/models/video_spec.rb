require 'rails_helper'

describe User do
  let(:video) { build_stubbed(:video) }

  it 'title should be present' do
    video.title = ''
    expect(video.valid?).to be false
    expect(video.errors[:title]).not_to be_empty
  end

  it 'url should be present' do
    video.url = ''
    expect(video.valid?).to be false
    expect(video.errors[:url]).not_to be_empty
  end

  it 'url should be without  http prefix' do
    video.url = 'youtu.be/sdfsdfsdf'
    expect(video.valid?).to be true
    expect(video.errors[:url]).to be_empty
  end

  it 'url should have valid google url' do
    video.url = 'http://google.ru/sdfsdfsdf'
    expect(video.valid?).to be false
    expect(video.errors[:url]).not_to be_empty
  end

  it 'url should be valid' do
    video.url = 'http://youtu.be/sdfsdfsdf'
    expect(video.valid?).to be true
    expect(video.errors).to be_empty
  end
end
