require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  sign_in_user 
  
  let(:question) { create(:question, user: @user) }  
  let!(:attachment) { create(:attachment, attachable: question) }  
  
  describe 'DELETE #destroy' do
  
    context 'delete own file' do
      it 'delete the own file' do
        expect { delete :destroy, params: { id: attachment, format: :js } }.to change(question.attachments, :count).by(-1)
      end

      it 'render to destroy' do
        delete :destroy, params: { id: attachment, format: :js}
        expect(request).to render_template :destroy
      end
    end

    context 'delete the foreign file' do
      let!(:foreign_user) { create(:user) } 
      let!(:foreign_question) { create(:question, user: foreign_user) }
      let!(:attachment) { create(:attachment, attachable: foreign_question) }

      it 'delete the foreign file' do
        expect { delete :destroy, params: { id: attachment, format: :js} }.to_not change(foreign_question.attachments, :count)
      end

      it 'render to destroy template' do
        delete :destroy, params: { id: attachment, format: :js }
        expect(request).to render_template :destroy
      end
    end
  end
end

