require 'rails_helper'

describe 'User Test', type: :feature do
  it 'show' do
    visit('/users/sign_in')
    within('#new_user') do
      fill_in 'Email', with: 'user@example.com'
    end
  end
end