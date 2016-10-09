require_relative 'acceptance_helper'

feature 'add comment to answer and question', %q{
  In order to comment answera and questions,
  As an user,
  I want to be able to comment
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user)}

  context "Authenticated user" do  

    background do
      sign_in(user)
      visit question_path(question)
    end

     scenario 'Authenticated user comments to the question', js: true do
        
        within '.question-comments' do
          fill_in 'Write your comment:', with: 'bla bla bla'
          click_on 'Post comment'
          expect(page).to have_content 'bla bla bla'        
        end
      end 

      scenario 'Authenticated user comments to the answer', js: true do
        
        within ".answer-#{answer.id}" do
          fill_in 'Write your comment:', with: 'Again bla bla bla'
          click_on 'Post comment'
          expect(page).to have_content 'Again bla bla bla'        
        end
      end  
  end

  context 'Non Authenticated user' do

    scenario 'Non Authenticated user comments', js: true do
      visit question_path(question)
      expect(page).to_not have_content 'Write your comment:' 
    end
  end
end