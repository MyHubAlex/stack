require 'rails_helper'

feature 'User can delete own question', %q{
  In order to user can delete question
  As an User
  I want to be able delete question 
} do 

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user delete own question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Your question was deleted'
    expect(currunt_path).to eq questions_path  
  end
end