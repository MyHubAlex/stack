require 'rails_helper'

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
  end

  describe 'DELETE #destroy' do
    sign_in_user    
    
    context 'delete own question' do
      let!(:question) { create(:question, user: @user) }
      it 'delete own the question' do
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
end
