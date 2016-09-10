require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question } 
  it { should belong_to :user }  
  
  it { should validate_presence_of :content}
  it { should validate_presence_of :user_id}
  it { should validate_presence_of :question_id}   

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer_best) { create(:answer, question: question, user: user, best: true) }   
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'select the best answer' do    
    it 'answer set the best' do
      answer.is_best
      expect(answer.best).to eq true
      expect(Answer.first).to eq answer
    end

    it 'best answer yet not the best' do
      answer.is_best
      answer_best.reload
      expect(answer_best.best).to_not eq true
    end    
  end   
end
