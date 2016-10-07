require_relative 'acceptance_helper'

feature 'User can delete own question', %q{
  In order to user can delete question
  As an User
  I want to be able delete question 
} do 

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:user_alien) { create(:user) }

  scenario 'Authenticated user delete own question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Your question was deleted'
    expect(page).to_not have_content question.title
    expect(current_path).to eq questions_path  
  end

  scenario 'Authenticated user delete foreign question' do
    sign_in(user_alien)
    visit question_path(question)
    
    expect(page).to_not have_content 'Delete question'    
  end
end