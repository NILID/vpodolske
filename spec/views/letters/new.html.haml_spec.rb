require 'rails_helper'

RSpec.describe "letters/new", type: :view do
  before(:each) do
    assign(:letter, build(:letter))
  end

  it "renders new letter form" do
    render

    assert_select "form[action=?][method=?]", letters_path, "post" do

      assert_select "textarea#letter_content[name=?]", "letter[content]"

      assert_select "input#letter_email[name=?]", "letter[email]"
    end
  end
end
