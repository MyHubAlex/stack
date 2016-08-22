require 'rails_helper'

feature 'create an answer to the question', %q{
  In order to help proplem
  As a authenticated user
  I want to be able create answer to the question 
} do

    given(:user) { create(:user) }
    given(:question) { create(:question) }

    scenario 'Authenticated user answers to the question' do
      sign_in(user)
      visit question_path(question)

      #save_and_open_page
      
      fill_in 'Write your answer:', with: 'Again bla bla bla'
      click_on 'Post'
      
      #save_and_open_page

      expect(page).to have_content 'Your answer created'
      expect(page).to have_content 'Again bla bla bla'
      expect(current_path).to eq question_path(question)
    end  
end

