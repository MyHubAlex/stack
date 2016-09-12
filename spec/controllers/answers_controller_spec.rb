require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user 
  
  let(:question) { create(:question, user: @user) }  
  let!(:answer) { create(:answer, question: question, user: @user) }
  
  describe 'POST #create' do
 
    context 'with valid attributes' do
      it 'add a new item into datebase' do
        expect{ post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'render create temlpate' do
        post :create , params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(request).to render_template :create
      end

      it 'new question belongs to user' do
        post :create , params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(question.user_id).to eq @user.id
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new item into database' do
        expect{ post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js } }.to_not change(Answer, :count)
      end

      it 'render create temlpate' do
        post :create , params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(request).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
  
    context 'delete own answer' do
      it 'delete the own answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to change(question.answers, :count).by(-1)
      end

      it 'render to destroy' do
        delete :destroy, params: { id: answer, format: :js}
        expect(request).to render_template :destroy
      end
    end

    context 'delete the foreign answer' do
      let!(:foreign_user) { create(:user) } 
      let!(:foreign_answer) { create(:answer, question: question, user: foreign_user) }

      it 'delete the foreign answer' do
        expect { delete :destroy, params: { id: foreign_answer, format: :js} }.to_not change(Answer, :count)
      end

      it 'render to destroy template' do
        delete :destroy, params: { id: answer, format: :js }
        expect(request).to render_template :destroy
      end
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: answer } }

    it 'assigns the edit Answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

  end

  describe 'PATCH #update' do

    context 'update own answer with valid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question }, format: :js }
      it 'assigns the update answer to @answer' do        
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { content: 'new content' }, question_id: question, format: :js}
        answer.reload
        expect(answer.content).to eq 'new content'
      end 

      it 'renders to update template' do
        expect(response).to render_template :update
      end
    end

    context 'update foreign answer with valid attributes' do
      let(:foreign_answer) { create(:answer, question: question)}

      it 'no changes answer attributes' do
        patch :update, params: { id: foreign_answer, answer: { content: 'new content' }, question_id: question, format: :js}
        answer.reload
        expect(answer.content).to eq foreign_answer.content
      end 

      it 'renders to update template' do
        patch :update, params: { id: foreign_answer, answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      before { patch :update, params: { id: answer, answer: { content: nil }, question_id: question, format: :js } }
      it 'changes questions invalid attributes' do
        answer.reload
        expect(answer.content).to eq answer.content        
      end

      it 'renders to update template' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #best' do
    context 'select the best to own answer' do
      let!(:best_answer) { create(:answer, question: question, user: @user, best: true )}
      before { patch :best, params: { id: answer, answer: attributes_for(:answer), question_id: question, best: true }, format: :js }
      before { answer.reload}
      it 'assigns the best answer to @answer' do                
        expect(assigns(:answer)).to eq answer
      end

      it 'set to answer sign best' do                
        expect(answer.best).to eq true
      end
      it 'another best anwser should be false' do
        best_answer.reload
        expect(best_answer.best).to eq false
      end
    end

  end
end

