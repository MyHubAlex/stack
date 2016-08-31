require 'rails_helper'

feature 'show the list of questions', %q{
  In order to anyone can show a list of questions
  As an anyone
  I want to be able to show a list of questions
} do

  given(:user) { create(:user) }
  given!(:questions) { [create(:question, user: user), Question.create(title: '1234567890123123123', body: 'abracadabra', user: user)] }

  scenario 'Authenticated user show a list of questions' do
    sign_in(user)

    visit questions_path
    
    questions.each do |question|
      expect(page).to have_content question.title
    end    
  end

  scenario 'UnAuthenticated user show a list of questions' do
    visit questions_path
    
    questions.each do |question|
      expect(page).to have_content question.title
    end    
  end
end 