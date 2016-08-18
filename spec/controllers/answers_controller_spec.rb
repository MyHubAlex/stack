require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

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
        expect{ post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'redirect to view question' do
        post :create , params: { question_id: question, answer: attributes_for(:answer) }
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
end
