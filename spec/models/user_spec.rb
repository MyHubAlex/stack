require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password } 

  it { should have_many :questions}
  it { should have_many :answers} 
  it { should have_many :subscriptions} 

  describe '.find_for_oath' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')  
        expect(User.find_for_oath(auth)).to eq user
      end  
    end  

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        it 'does not create new user' do
          expect { User.find_for_oath(auth) }.to_not change(User, :count)
        end 

        it 'create authorization for user' do
          expect { User.find_for_oath(auth) }.to change(user.authorizations, :count).by(1)     
        end   

        it 'creates authorization with provider and uid' do          
          authorization = User.find_for_oath(auth).authorizations.first
          
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oath(auth)).to eq user
        end
      end  
    end  

    context 'user does not exit' do      
        context 'with email' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

          it 'creates new user' do
            expect { User.find_for_oath(auth).to change(User, :count).by(1) }
          end
          it 'returns new user' do
            expect(User.find_for_oath(auth)).to  be_a(User)
          end
          it 'fills user email' do
            user = User.find_for_oath(auth)
            expect(user.email).to eq auth.info.email
          end
          it 'create authorization for user' do
            user = User.find_for_oath(auth)
            expect(user.authorizations).to_not be_empty        
          end
          it 'create authorization with provider and uid' do
            authorization = User.find_for_oath(auth).authorizations.first

            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid 
          end 
        end 

        context 'no email' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

          it 'return new user' do
            expect { User.find_for_oath(auth).to eq be_new(User) }
          end
        end
    end
  end

  describe '.send_daily_digest' do
    let(:users) { create_list(:user, 2) }   

    it 'should send daily to all users' do
      users.each { |user| expect(DailyMailer).to receive(:digest).with(user).and_call_original }
      User.send_daily_digest
    end 
  end
end