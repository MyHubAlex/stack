require_relative 'acceptance_helper'

feature 'change own question',%q{
  In order to user can change own question
  As an user
  I want to be able change my question
} do 
   
  given(:user) { create(:user) }
  given(:user_alien) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user change own question', js: true do
    sign_in(user)
    visit question_path(question)
    click_on "Edit question"
    fill_in 'Title', with: 'new_title*new_title*new_title'
    fill_in 'Body', with: 'new body'
    click_on 'Save' 

    within '.question' do
      expect(page).to have_content 'new_title*new_title*new_title'
      expect(page).to have_content 'new body'
    end
    expect(current_path).to eq question_path(question)
  end 

  scenario 'non authenticated user change own question' do
    visit edit_question_path(question) 

    expect(page).to_not have_content 'Edit question'    
  end 

  scenario 'Authenticated user change foreign question' do
    sign_in(user_alien)
    visit edit_question_path(question) 

    expect(page).to_not have_content 'Edit question'
  end 
end