require_relative 'acceptance_helper'

feature 'add files to question', %q{
  In order to illustrated my question,
  As an user,
  I want to be able attach file
} do

  given(:user) { create(:user) }
  
  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds files when ask the question' do
    fill_in 'Title', with: 'Test question * Test question'
    fill_in 'Body', with: 'bla bla bla'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'   

    expect(page).to have_content('spec_helper.rb')
  end
   
end