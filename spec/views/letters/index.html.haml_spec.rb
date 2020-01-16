require 'rails_helper'

RSpec.describe 'letters/index', type: :view do
  before(:each) do
    @letters = create_list(:letter, 2)
  end

  it 'renders a list of letters' do
    render
    assert_select 'tr>td', text: 'MyText'.to_s, count: 2
    assert_select 'tr>td', text: 'example@vpodolske_fake.com'.to_s, count: 2
  end
end
