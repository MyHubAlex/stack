require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    let(:question) { create(:question) }
    
    it_behaves_like "API Authenticable"
    
    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      
      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }
      
      it_behaves_like "API success" 
    
      it 'returns list of answers' do
        expect(response.body).to have_json_size(2)
      end
      
      %w(id content created_at updated_at).each do |attr|
        it "Answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answers.first.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
    def do_request(options = {})
      get  "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end 
  end
  
  describe 'GET /show' do
    let(:answer) { create(:answer) }
    it_behaves_like "API Authenticable"
        
    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comments) { create_list(:comment_for_question, 2, commentable: answer) }
      let!(:attachments) { create_list(:attachment, 2, attachable: answer) }
      
      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }
      
      it_behaves_like "API success" 
    
      %w(id content created_at updated_at).each do |attr|
        it "Answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end
      
      it_behaves_like "API Comments"  
      it_behaves_like "API Attachments"          
    end
    def do_request(options = {})
      get  "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end 
  end
  
  describe 'POST /create' do
    let(:question) { create(:question) }
    it_behaves_like "API Authenticable"
        
    context 'authorized' do
      let(:access_token) { create(:access_token) }
      
      context 'with valid attributes' do
        it 'saves the new answer in the database' do
         expect { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token } }.to change(Answer, :count).by(1)
        end 
        
        it 'answer belongs to user' do
          post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token }
          expect(assigns(:answer).user).to eq User.find(access_token.resource_owner_id)
        end
        
        it "returns answer" do
          post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token }
          %w(id content created_at updated_at).each do |attr|
            expect(response.body).to be_json_eql(Answer.first.send(attr.to_sym).to_json).at_path("#{attr}")
          end
        end
      end
      
      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token } }.to_not change(Answer, :count)
        end
        
        it 'returns error' do
          post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token }
          expect(response.body).to have_json_path("errors")
        end
      end  
    end
    def do_request(options = {})
      get  "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end 
  end
end