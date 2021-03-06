require 'rails_helper'

describe 'questions API' do
  describe 'GET /index' do

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) } 
      let(:question) { questions.first}

      before { get '/api/v1/questions', params:{ format: :json, access_token: access_token.token } }

      it_behaves_like "API success"

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end  

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end         
    end
    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end 
  end

  describe 'GET /show' do
    let(:question) { create(:question) }
    
    it_behaves_like "API Authenticable"
    
    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comments) { create_list(:comment_for_question, 2, commentable: question) }
      let!(:attachments) { create_list(:attachment, 2, attachable: question) }
      
      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }
      
      it_behaves_like "API success"

      it_behaves_like "API Comments" 

      it_behaves_like "API Attachments" 

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end
    end
    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do

    it_behaves_like "API Authenticable"
    
    context 'authorized' do
      let(:access_token) { create(:access_token) }
      
      context 'with valid attributes' do
        it 'saves the new question in the database' do
          expect { post '/api/v1/questions', params: { question: attributes_for(:question), format: :json, access_token: access_token.token } }.to change(Question, :count).by(1)
        end 

        it 'question belongs to user' do
          post '/api/v1/questions', params: { question: attributes_for(:question), format: :json, access_token: access_token.token }
          expect(assigns(:question).user).to eq User.find(access_token.resource_owner_id)
        end

        it "returns question" do
          post '/api/v1/questions', params: { question: attributes_for(:question), format: :json, access_token: access_token.token }
          %w(id title body created_at updated_at).each do |attr|
            expect(response.body).to be_json_eql(Question.last.send(attr.to_sym).to_json).at_path("#{attr}")
          end
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post '/api/v1/questions', params: { question: attributes_for(:invalid_question), format: :json, access_token: access_token.token } }.to_not change(Question, :count)
        end

        it 'returns error' do
          post '/api/v1/questions', params: { question: attributes_for(:invalid_question), format: :json, access_token: access_token.token }
          expect(response.body).to have_json_path("errors")
        end     
      end 
    end    
    def do_request(options = {})
      post '/api/v1/questions', params: { format: :json }.merge(options)
    end 
  end
end