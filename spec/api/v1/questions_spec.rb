require 'rails_helper'

describe 'questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if no access_token' do
        get '/api/v1/questions', format: :json 
        expect(response.status).to eq 401     
      end

      it 'returns 401 status if wrong access_token' do
        get '/api/v1/questions', format: :json, access_token: '1234'       
        expect(response.status).to eq 401
      end      
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) } 
      let(:question) { questions.first}

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status ' do        
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end  

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end 
    end
  end

  describe 'GET /show' do
    let(:question) { create(:question) }
    
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", format: :json        
        expect(response.status).to eq 401
      end
      
      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: '12345'
        
        expect(response.status).to eq 401
      end
    end
    
    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comments) { create_list(:comment_for_question, 2, commentable: question) }
      let!(:attachments) { create_list(:attachment, 2, attachable: question) }
      
      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }
      
      it 'returns 200 status code' do
        expect(response).to be_success
      end
    
      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end
      
         
      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(2).at_path("comments")
        end
        
        %w(id body ).each do |attr|
          it "Comments object contains #{attr}" do
            expect(response.body).to be_json_eql(comments.last.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end  

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(2).at_path("attachments")
        end
        
        it "Attachments object contains url" do
          expect(response.body).to be_json_eql(attachments.first.file.url.to_json).at_path("attachments/0/url")
        end
      end  
    end
  end

  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post '/api/v1/questions', params: { question: attributes_for(:question), format: :json }
        expect(response.status).to eq 401
      end
      
      it 'returns 401 status if access_token is invalid' do
        post '/api/v1/questions', params: { question: attributes_for(:question), format: :json, access_token: '12345' }
        expect(response.status).to eq 401
      end
    end
    
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
  end
end