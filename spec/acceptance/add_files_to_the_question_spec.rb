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

  scenario 'User adds files when ask the question', js: true do
    fill_in 'Title', with: 'Test question * Test question'
    fill_in 'Body', with: 'bla bla bla'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'   

    expect(page).to have_content('spec_helper.rb')
  end

  scenario 'User adds some files when ask the question' , js: true do
    fill_in 'Title', with: 'Test question * Test question'
    fill_in 'Body', with: 'bla bla bla'
    click_on 'add file'

    within(all(:css, '.nested-fields').first) do  
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    within(all(:css,'.nested-fields').last) do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Create'   

    expect(page).to have_link 'spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb'
  end

  scenario 'User adds file when edit question', js: true do
    question = create(:question, user: user) 
    visit question_path(question)

    within ".question" do
      click_on 'Edit question'
      click_on 'add file'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Save'
      expect(page).to have_content 'spec_helper.rb'
    end  
  end
   
end