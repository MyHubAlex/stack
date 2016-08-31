require 'rails_helper'

feature 'change own answer',%q{
  In order to user can change own answer
  As an user
  I want to be able change my answer
} do

  given!(:user) { create(:user) }
  given(:user_alien) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user change own answer' do
    sign_in(user)
    visit edit_answer_path(answer) 
    click_on 'Edit answer'
    
    expect(page).to have_content 'Your answer was changed'
    expect(current_path).to eq question_path(question)
  end 

  scenario 'Non Authenticated user change own answer' do
    visit edit_answer_path(answer) 
       
    expect(page).to_not have_content 'Edit question'
  end 

  scenario 'Authenticated user change foreign question' do
    sign_in(user_alien)
    visit edit_question_path(question) 

    expect(page).to_not have_content 'Edit question'
  end 
end