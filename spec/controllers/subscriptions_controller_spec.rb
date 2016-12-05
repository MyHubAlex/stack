require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  
  describe 'POST #create' do
    sign_in_user
    
    let!(:question) { create(:question) }
    
    it 'should be create new subscription' do
      expect { post :create, format: :json, params: { question_id: question.id } }.to change(Subscription, :count).by(1)
    end
   end

   describe 'DELETE #destroy' do
    sign_in_user
    let!(:question) { create(:question) }  
    let!(:subscription) { create(:subscription, question: question, user: @user) }
    
    it 'should be delete subscription' do
      expect { delete :destroy, format: :json, params: { id: subscription.id, question_id: question.id, user: @user } }.to change(Subscription, :count).by(-1)
    end
   end
end
