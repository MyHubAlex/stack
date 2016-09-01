require 'rails_helper'

feature 'create an answer to the question', %q{
  In order to help proplem
  As a authenticated user
  I want to be able create answer to the question 
} do

    given(:user) { create(:user) }
    given(:question) { create(:question, user: user ) }

    scenario 'Authenticated user answers to the question', js: true do
      sign_in(user)
      visit question_path(question)

      fill_in 'Write your answer:', with: 'Again bla bla bla'
      click_on 'Post'
  
      expect(page).to have_content 'Again bla bla bla'
      expect(current_path).to eq question_path(question)
    end  
end

