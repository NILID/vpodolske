require 'rails_helper'

RSpec.describe "blocks/new", type: :view do
  before(:each) do
    assign(:block, Block.new(
      :content => "MyText",
      :type => "",
      :position => 1,
      :page => nil
    ))
  end

  it "renders new block form" do
    render

    assert_select "form[action=?][method=?]", blocks_path, "post" do

      assert_select "textarea[name=?]", "block[content]"

      assert_select "input[name=?]", "block[type]"

      assert_select "input[name=?]", "block[position]"

      assert_select "input[name=?]", "block[page_id]"
    end
  end
end
