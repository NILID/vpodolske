require 'rails_helper'

RSpec.describe "comments/index", type: :view do

  let!(:comments) { create_list(:comment, 2) }

  it "renders a list of comments" do
    @comments = comments
    render
    assert_select "ul>li>.media-body>p", :text => "MyText".to_s, :count => 2
    assert_select "ul>li>.media-body>.comment-title>span", :text => rusdatecom(@comments.first.created_at), :count => 2
  end
end
