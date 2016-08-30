require 'rails_helper'

feature 'show a question and answers', %q{
  In order to find out answer,
  As an anyone 
  I want to be able to see all answers to question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'Autenticated user show answers' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |q|
      expect(page).to have_content q.content 
    end
  end

  scenario 'Unautenticated user show answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |a|
      expect(page).to have_content a.content 
    end
  end
end