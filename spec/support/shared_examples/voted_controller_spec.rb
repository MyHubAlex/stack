require 'rails_helper'

RSpec.shared_examples 'voted' do |parameter|

  sign_in_user 
  let(:user){ create(:user) }
  let!(:votable){ create(parameter.to_sym, user: user) } 
  let!(:user_votable){ create(parameter.to_sym, user: @user) } 

  describe  'POST #vote_up' do
    context 'foreign votable' do
      it "add a new vote into database" do
        expect{ post :vote_up, params: { id: votable , format: :json } }.to change(votable.votes, :count).by(1)
      end

      it "new vote equal 1" do
        post :vote_up, params: { id: votable , format: :json } 
        expect(votable.votes.where(user: @user)[0].point).to eq 1        
      end

      it "can't vote twice" do
        post :vote_up, params: { id: votable , format: :json } 
        post :vote_up, params: { id: votable , format: :json } 
        expect(votable.votes.where(user: @user).count).to eq 1
      end 
    end

    context 'own votable' do
      it "no change into database" do
        expect{ post :vote_up, params: { id: user_votable , format: :json } }.to change(votable.votes, :count).by(0)
      end
    end
  end

  describe  'POST #vote_down' do
    context 'foreign votable' do
      it "add a new vote into database" do
        expect{ post :vote_down, params: { id: votable , format: :json } }.to change(votable.votes, :count).by(1)
      end

      it "new vote equal -1" do
        post :vote_down, params: { id: votable , format: :json } 
        expect(votable.votes.where(user: @user)[0].point).to eq -1        
      end

      it "can't vote twice" do
        post :vote_down, params: { id: votable , format: :json } 
        post :vote_down, params: { id: votable , format: :json } 
        expect(votable.votes.where(user: @user).count).to eq 1
      end 
    end

    context 'own votable' do
      it "no change into database" do
        expect{ post :vote_down, params: { id: user_votable , format: :json } }.to change(votable.votes, :count).by(0)
      end
    end
  end

  describe 'POST #vote_cancel' do
    before { post :vote_up, params: { id: votable , format: :json } }

    context 'foreign votable' do
      it "change into database by -1" do
        expect{ post :vote_cancel, params: { id: votable , format: :json } }.to change(votable.votes, :count).by(-1)
      end

      it "no item into database" do
        post :vote_cancel, params: { id: votable , format: :json } 
        expect(votable.votes.where(user: @user).count).to eq 0
      end 
    end

    context 'own votable' do
      it "no change into database" do
        expect{ post :vote_cancel, params: { id: user_votable , format: :json } }.to change(votable.votes, :count).by(0)
      end
    end

  end 

end 