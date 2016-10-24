require_relative 'acceptance_helper'

feature 'User sign up', %q{
  In order to be able to ask question and to answer to question
  As an user
  I want to be able to sign up
} do

    given(:user) { create(:user) }

    scenario 'sign up with valid attribute' do
      sign_up(user)
      #expect(page).to have_content "Welcome! You have signed up successfully."
      open_email('alex@test.ru')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end

    scenario 'sign up with invalid attribute' do
      visit new_user_registration_path
      #save_and_open_page
      fill_in 'Email', with: 'wrong@mail.ru'
      fill_in 'Password', with: nil
      fill_in 'Password confirmation', with: '12345678'
      click_on 'Sign up' 

      expect(current_path).to eq user_registration_path  
      expect(page).to have_content "error"
    end
end