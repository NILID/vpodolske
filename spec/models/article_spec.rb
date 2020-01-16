require 'rails_helper'

RSpec.describe Article, type: :model do

  let(:article) { build(:article) }

  context 'should' do
    it 'have title' do
      article.title = nil
      expect(article.valid?).to be false
      expect(article.errors[:title]).not_to be_empty
    end

    it 'have uniq url' do
      article.save!
      new_article = build(:article, url: article.url)
      expect(new_article.valid?).to be false
      expect(new_article.errors[:url]).not_to be_empty
    end

    it 'have empty url' do
      new_article = build(:article, url: '')
      expect(new_article.valid?).to be true
      expect(new_article.errors[:url]).to be_empty
    end
  end
end
