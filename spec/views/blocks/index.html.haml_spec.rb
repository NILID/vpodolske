require 'rails_helper'

RSpec.describe "blocks/index", type: :view do
  before(:each) do
    assign(:blocks, [
      Block.create!(
        :content => "MyText",
        :type => "Type",
        :position => 2,
        :page => nil
      ),
      Block.create!(
        :content => "MyText",
        :type => "Type",
        :position => 2,
        :page => nil
      )
    ])
  end

  it "renders a list of blocks" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
