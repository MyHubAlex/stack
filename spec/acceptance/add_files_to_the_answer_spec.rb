require_relative 'acceptance_helper'

feature 'add files to answer', %q{
  In order to illustrated my answer,
  As an user,
  I want to be able attach file
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds files when ask the answer' do
    fill_in 'Write your answer', with: 'bla bla bla !!!!!!!!!!!!'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Post'   

    within 'answers' do
      expect(page).to have_content('spec_helper.rb')
    end
  end
    
end