require 'rails_helper'

RSpec.describe "letters/show", type: :view do
  before(:each) do
    @letter = assign(:letter, create(:letter))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Email/)
  end
end
