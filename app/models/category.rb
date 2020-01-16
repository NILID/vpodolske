class Category < ActiveRecord::Base
  belongs_to :categorable, polymorphic: true
  has_and_belongs_to_many :organizations
  has_ancestry

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  validates :title, uniqueness: true, presence: true

  def make_organizations_count
    update_attribute(:organizations_count, organizations.pluck(:id).count)
  end

  ransacker :casetitle, formatter: proc { |v| v.mb_chars.upcase.to_s } do |parent|
    Arel::Nodes::NamedFunction.new('UPPER',[parent.table[:title]])
  end

  def self.ids_from_tokens(tokens)
    tokens.select{ |i| i[/<<<(.+?)>>>/] }.each do |t|
      token = create!(title: $1)
      tokens[tokens.index(t)] = token.id
    end
    tokens
  end
end
