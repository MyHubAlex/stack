require_relative 'acceptance_helper'

feature 'delete files from question', %q{
  In order to delete files,
  As an user,
  I want to be able files from question
} do

  given!(:user) { create(:user) }
  given!(:user_alien) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:file) { create(:attachment, attachable: question) }

  scenario 'User delete own file', js: true  do

    sign_in(user)
    visit question_path(question)
    within ".file-id-#{file.id}" do
      click_on 'Delete file' 
      expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/#{file.id}/'
    end  
  end
   
  scenario 'User delete a file from foreign question', js: true  do
    sign_in(user_alien)
    visit question_path(question)
    within ".file-id-#{file.id}" do
      expect(page).to_not have_content "Delete file"
    end  
  end 
end