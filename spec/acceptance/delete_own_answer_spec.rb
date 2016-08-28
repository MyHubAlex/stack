require 'rails_helper'

feature 'User can delete own aswer', %q{
  In order to user can delete answer
  As an User
  I want to be able delete answer 
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user delete own question' do
    sign_in(user)
    visit question_path(question)
    click_on "Delete answer"

    expect(page).to have_content 'Your answer was deleted'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Anauthenticated user delete question' do
    visit question_path(question)
    
    expect(page).to have_content 'Delete answer'    
  end
end