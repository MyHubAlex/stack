require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #confirm_email' do
    before do 
        mock_auth_hash
        session['devise.omniauth_data'] = OmniAuth.config.mock_auth[:twitter]
    end

    it 'saves the new user in the database' do
        expect { post :confirm_email, params: { user: attributes_for(:user) } }.to change(User, :count).by(1)
    end

    it 'create authorization for user' do
        expect { post :confirm_email, params: { user: attributes_for(:user) } }.to change(Authorization, :count).by(1)
    end  

  end
end
