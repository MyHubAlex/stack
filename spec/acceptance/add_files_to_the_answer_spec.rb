require_relative 'acceptance_helper'

feature 'add files to answer', %q{
  In order to illustrated my answer,
  As an user,
  I want to be able attach file
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user)}

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds files when answer', js: true do
    fill_in 'Write your answer', with: 'bla bla bla !!!!!!!!!!!!'
    click_on 'add file'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Post'   

    within '.answers' do
      expect(page).to have_content('spec_helper.rb')
    end
  end
  
   scenario 'User adds some files when answer' , js: true do
    fill_in 'Write your answer', with: 'bla bla bla !!!!!!!!!!!!'
    
    click_on 'add file'

    within(all(:css, '.nested-fields').first) do  
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on 'add file'

     within(all(:css,'.nested-fields').last) do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Post'   

    expect(page).to have_link 'spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb'
  end

  scenario 'User adds file when edit answer', js: true do
    
    within ".answer-#{answer.id}" do
      click_on 'Edit answer'
      click_on 'add file'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Save answer'
      expect(page).to have_content 'spec_helper.rb'
    end  
  end
end