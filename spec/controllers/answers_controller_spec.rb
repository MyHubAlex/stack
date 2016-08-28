require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user 
  
  let(:question) { create(:question, user: @user) }  
  let!(:answer) { create(:answer, question: question, user: @user) }
  
  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns the requested question to @question' do      
      expect(assigns(:answer)).to be_a_new(Answer)  
    end

    it 'renders a new view' do
      expect(request).to render_template :new
    end
  end

  describe 'POST #create' do
 
    context 'with valid attributes' do
      it 'add a new item into datebase' do
        expect{ post :create, params: { question_id: question, answer: attributes_for(:answer, user_id: @user) } }.to change(question.answers, :count).by(1)
      end

      it 'redirect to view question' do
        post :create , params: { question_id: question, answer: attributes_for(:answer, user_id: @user) }
        expect(request).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new item into database' do
        expect{ post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) } 
        expect(request).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
  
    context 'delete own answer' do
      it 'delete the own answer' do
        expect { delete :destroy, params: { id: answer} }.to change(question.answers, :count).by(-1)
      end

      it 'redirect to view question' do
        delete :destroy, params: { id: answer}
        expect(request).to redirect_to question
      end
    end

    context 'delete the foreign answer' do
      let!(:foreign_user) { create(:user) } 
      let!(:foreign_answer) { create(:answer, question: question, user: foreign_user) }

      it 'delete the foreign answer' do
        expect { delete :destroy, params: { id: foreign_answer} }.to_not change(Answer, :count)
      end

      it 'redirect to view question' do
        delete :destroy, params: { id: answer }
        expect(request).to redirect_to question
      end
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: answer } }

    it 'assigns the edit Answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do

    context 'update own answer with valid attributes' do
      it 'assigns the update answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { content: 'new content' }, question_id: question}
        answer.reload
        expect(answer.content).to eq 'new content'
      end 

      it 'redirect to questin' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question
      end
    end

    context 'update foreign answer with valid attributes' do
      let(:foreign_answer) { create(:answer, question: question)}

      it 'no changes answer attributes' do
        patch :update, params: { id: foreign_answer, answer: { content: 'new content' }, question_id: question}
        answer.reload
        expect(answer.content).to eq foreign_answer.content
      end 

      it 're-renders to view edit' do
        patch :update, params: { id: foreign_answer, answer: attributes_for(:answer), question_id: question }
        expect(response).to render_template :edit
      end
    end

    context 'invalid attributes' do
      before { patch :update, params: { id: answer, answer: { content: nil }, question_id: question } }
      it 'changes questions invalid attributes' do
        answer.reload
        expect(answer.content).to eq answer.content        
      end

      it 're-renders to edit view' do
        expect(response).to render_template :edit
      end
    end
  end
end
