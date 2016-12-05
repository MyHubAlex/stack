require_relative 'acceptance_helper'

feature 'user can subscribes to question', %q{
  In order to keep in touch what happend with question,
  As an user,
  I want to be able to give mail
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
      
  describe 'Author of question' do
    before do 
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Can unsubscribe from own question', js: true do
      click_on 'Unsubscribe'

      within '.subscription' do
        expect(page).to have_content 'Вы отписалсиь от данного вопроса'
      end
    end
  end

  describe 'Authenticated user' do
 
    before do 
      sign_in(another_user)
      visit question_path(question)
    end
   
    scenario 'Can subscribe to the question', js: true do
 
      click_on 'Subscribe'

      within '.subscription' do
        expect(page).to have_content 'Вы подписались на данный вопрос'
      end
    end


    scenario 'Can unscribe from the question', js: true do
      click_on 'Subscribe'
      visit question_path(question)
      click_on 'Unsubscribe'
      
      within '.subscription' do       
        expect(page).to have_content 'Вы отписалсиь от данного вопроса' 
      end
    end
  end
end