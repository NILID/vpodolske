require 'rails_helper'

RSpec.describe "blocks/show", type: :view do
  before(:each) do
    @block = assign(:block, Block.create!(
      :content => "MyText",
      :type => "Type",
      :position => 2,
      :page => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
  end
end
