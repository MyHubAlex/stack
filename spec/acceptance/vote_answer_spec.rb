require_relative 'acceptance_helper'

feature 'User votes for an answer ', %q{
  In order to be able to mark a good answer
  As an user
  I want to be able to vote
} do

    given(:user) { create(:user) }
    given(:alien_user) { create(:user) }
    given!(:question) { create(:question, user: user) }
    given!(:answer) { create(:answer, question: question, user: alien_user) }
    given!(:own_answer) { create(:answer, question: question, user: user) }

    describe "Authenticated user" do

      background do
        sign_in(user)
        visit question_path(question)
      end
    

      describe 'Vote for foreign answer', js: true  do

        scenario 'vote for' do
          within ".answer-#{answer.id}" do
            click_on 'Vote up'
          
            expect(page).to have_content "rating: 1"          
          end
        end

        scenario 'vote 2 times', js: true do
          within ".answer-#{answer.id}" do
            click_on 'Vote up'
            expect(page).to have_content "rating: 1"          
            click_on 'Vote up'
            
            expect(page).to have_content "rating: 1"          
          end  
        end

        scenario 'negative vote', js: true do
          within ".answer-#{answer.id}" do
            click_on 'Vote down'
          
            expect(page).to have_content "rating: -1"          
          end
        end
        
        scenario 'cancel vote', js: true do
          within ".answer-#{answer.id}" do
            click_on 'Vote up'
            expect(page).to have_content "rating: 1"          
            click_on 'Vote cancel'
            
            expect(page).to have_content "rating: 0"          
          end  
        end  
      end 

      describe 'Vote for own answer'  do
        scenario "can't vote own answer", js: true do
          within ".answer-#{own_answer.id}" do        
            expect(page).to_not have_link 'Vote up'
            expect(page).to_not have_link 'Vote downp'
            expect(page).to_not have_link 'Vote cancel'          
          end
        end  
      end
    end

    describe "Authenticated user" do
      scenario 'Try votes an answer' do
        visit question_path(question)
        expect(page).to_not have_link 'Vote up'
        expect(page).to_not have_link 'Vote downp'
        expect(page).to_not have_link 'Vote cancel'
      end
    end    
end
