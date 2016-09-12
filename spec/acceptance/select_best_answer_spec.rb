require_relative 'acceptance_helper'

feature 'select the best answer', %q{
 In order to user could choose the best answer,
 As an user
 I want to be able select the right answer  
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer_another) { Answer.create(content: 'dddddd', user: user, question: question, best: true) }
                            
  scenario 'Autenticated user choose the best answer', js: true do 
    sign_in(user)
    visit question_path(question)

    within '.best_answer' do
      expect(page).to have_content(answer_another.content)
    end  
    expect(page.find('.answers').first('div')).to have_content(answer_another.content)
    within ".answer-#{answer.id}" do
      click_on 'The best answer'
    end

    within '.best_answer' do
      expect(page).to have_content(answer.content)
    end

    expect(page.find('.answers').first('div')).to have_content(answer.content)
            
  end

  scenario 'Nonautenticated user choose the best answer', js: true do 
    visit question_path(question)

    expect(page).to_not have_link('The best answer')
    
  end
end