require 'rails_helper'

feature 'User sign out', %q{
  In order to user sign out
  As an authenticated user
  I want to sign out
} do

  given(:user) { create(:user) }

  scenario 'authenticated user sign out' do
    sign_in(user)
    visit questions_path
    save_and_open_page
    click_on 'Sign out'    
  end
end