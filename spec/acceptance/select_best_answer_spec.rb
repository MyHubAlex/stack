require_relative 'acceptance_helper'

feature 'select the best answer', %q{
 In order to user could choose the best answer,
 As an user
 I want to be able select the right answer  
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Autenticated user choose the best answer', js: true do 
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_selector('.best_answer')

    click_on 'The best answer'

    within '.best_answer' do
      expect(page).to have_content(answer.content)
    end
    
    expect(page).to have_selector('.best_answer')      
  end

  scenario 'Nonautenticated user choose the best answer', js: true do 
    visit question_path(question)

    expect(page).to_not have_link('The best answer')
    
  end
end