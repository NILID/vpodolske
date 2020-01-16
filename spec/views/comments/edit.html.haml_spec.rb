require 'rails_helper'

RSpec.describe "comments/edit", type: :view do
  let!(:comment) { create(:comment) }

  it "renders the edit comment form" do
    @comment = comment
    @commentable = comment.commentable
    render

    assert_select "form[action=?][method=?]", polymorphic_path([@commentable, @comment]), "post" do

      assert_select "textarea#comment_content[name=?]", "comment[content]"

    end
  end
end
