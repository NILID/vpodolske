require 'rails_helper'

RSpec.describe "blocks/edit", type: :view do
  before(:each) do
    @block = assign(:block, Block.create!(
      :content => "MyText",
      :type => "",
      :position => 1,
      :page => nil
    ))
  end

  it "renders the edit block form" do
    render

    assert_select "form[action=?][method=?]", block_path(@block), "post" do

      assert_select "textarea[name=?]", "block[content]"

      assert_select "input[name=?]", "block[type]"

      assert_select "input[name=?]", "block[position]"

      assert_select "input[name=?]", "block[page_id]"
    end
  end
end
