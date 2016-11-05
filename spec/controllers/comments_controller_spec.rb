require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
    
  describe 'POST #create' do
    sign_in_user
    
    let!(:question) { create(:question, user: @user) }  
    let!(:answer) { create(:answer, question: question, user: @user) }

    context 'with valid attributes' do   
      it 'add a new comment into database' do
        expect{ post :create, params: { commentable_type: "question", comment: { body: "dsfsdf" }, question_id: question, user: @user, format: :js  } }.to change(Comment, :count).by(1)          
      end
    end

    context 'with invalid the question' do
      it 'add a new comment into database' do
        expect{ post :create, params: { commentable_type: "question", comment: { body: "" }, question_id: question, user: @user, format: :js  } }.to change(Comment, :count).by(0)          
      end
    end
    context 'PrivatePub' do
      it 'publishes new object' do
        expect(PrivatePub).to receive(:publish_to).with("/questions/#{question.id}/comments", anything)
        post :create, params: { commentable_type: "question", comment: { body: "dsfsdf" }, question_id: question, user: @user, format: :js  } 
      end
    end
  end

end
