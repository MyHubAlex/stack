require 'rails_helper'

RSpec.describe AnswerRespondJob, type: :job do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: another_user) }

  it 'send notice to subscriber of question' do
    expect(AnswerRespondMailer).to receive(:answers).with(user, answer).and_call_original
    AnswerRespondJob.perform_now(answer)
  end
end
