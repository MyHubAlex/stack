require_relative 'acceptance_helper'

feature 'change own answer',%q{
  In order to user can change own answer
  As an user
  I want to be able change my answer
} do

  given!(:user) { create(:user) }
  given(:user_alien) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  
  scenario 'Authenticated user change own answer', js: true do
    sign_in(user)
    visit question_path(question)

    within ".answer-#{answer.id}" do
      click_on 'Edit answer'
      fill_in 'Answer', with: 'new answer' 
      click_on 'Save answer'

      expect(page).to have_content('new answer')
      expect(page).to_not have_link('Save answer')
      expect(current_path).to eq question_path(question)
    end
  end 

  scenario 'Non Authenticated user change own answer', js: true do
    visit question_path(question) 
       
    expect(page).to_not have_content 'Edit answer'
  end 

  scenario 'Authenticated user change foreign answer', js: true do
    sign_in(user_alien)
    visit question_path(question)  

    within ".answer-#{answer.id}" do
      expect(page).to_not have_link('Edit answer')      
    end
  end 
end