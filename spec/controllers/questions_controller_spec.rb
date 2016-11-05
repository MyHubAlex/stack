require 'rails_helper'
require Rails.root.join "spec/support/shared_examples/voted_controller_spec.rb"

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    sign_in_user
    let(:questions) { create_list(:question, 2, user: @user) }
    
    before do
      get :index
    end

    it "populates an array of all questions" do  
       expect(assigns(:questions)).to match_array(questions)
    end

    it "renders index view" do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    sign_in_user
    let(:question) { create(:question, user: @user) }

    before {get :show, params: {id: question}}

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }
    it "assigns a new Question to @question" do
      expect(assigns(:question)).to be_a_new(Question)    
    end  

    it "renders new view" do
      expect(response).to render_template :new
    end
  end
  
  describe 'POST #create' do
    sign_in_user
    
    context 'with valid attributes' do   
      it 'add a new question into database' do
        expect{ post :create, params: { question: attributes_for(:question), user: @user } }.to change(Question, :count).by(1)          
      end

      it 'redirect to show view' do
        post :create, params: { question: attributes_for(:question), user: @user}
        expect(response).to redirect_to assigns(:question)   
      end  
    end

    context 'with invalid the question' do
      it 'do not add a new question into database' do
        expect{ post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)          
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new 
      end
    end

    context 'PrivatePub' do
      it 'publishes new question' do
        expect(PrivatePub).to receive(:publish_to).with('/questions', anything)
        post :create, question: attributes_for(:question)
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user    
    
    context 'delete own question' do
      let!(:question) { create(:question, user: @user) }
      it 'delete the own question' do
        expect { delete :destroy, params: { id: question, user: @user } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'delete a strange question' do
      let!(:user) { create(:user) }
      let!(:question) { create(:question, user: user) }

      it 'delete the strange question' do
        expect { delete :destroy, params: { id: question, user: user } }.to_not change(Question, :count)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: question, user: user }
        expect(response).to redirect_to question
      end
    end
  end

  describe 'GET #edit' do
    sign_in_user
    let(:question) { create(:question, user: @user) }
    before { get :edit, params: { id: question }  }

    it 'assigns the edit Question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let!(:question) { create(:question, user: @user) }
    
    context 'edit own question with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end 

      it 'changes questions attributes' do
        patch :update, params: { id: question, question: { title: 'new title*new title*new title', body: 'new body', user: @user }, format: :js }
        question.reload
        expect(question.title).to eq 'new title*new title*new title'
        expect(question.body).to eq 'new body'
      end  

      it 'renders to the updates template' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to render_template :update
      end
    end

    context 'edit foreign question with valid attributes' do
      let(:foreign_user) { create(:user) }
      let(:question) { create(:question, user: foreign_user) }

      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end 

      it 'changes questions attributes' do
        patch :update, params: { id: question, question: { title: 'new title*new title*new title', body: 'new body', user: @user }, format: :js }
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end  

      it 're-renders to update' do
        patch :update, params: { id: question, question: { title: 'new title*new title*new title', body: 'new body', user: @user }, format: :js }
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      before { patch :update, params: { id: question, question: { title: 'nil', body: 'new body', user: @user }, format: :js } }
      it 'changes questions invalid attributes' do
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 're-renders to update' do
        expect(response).to render_template :update
      end
    end
  end

  it_behaves_like "voted", "question"
end
