require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.find' do
    let!(:params) { { a: 'Question', q: 'abracadabra' } }
    
    it 'find' do
      expect(ThinkingSphinx).to receive(:search).with('abracadabra', classes: [Question]).and_call_original
      Search.find(params)
    end
  end
end