shared_examples_for 'API Authenticable' do
  context 'unauthorized' do
    it 'returns 401 status if no access_token' do
      do_request 
      expect(response.status).to eq 401     
    end

    it 'returns 401 status if wrong access_token' do
      do_request(access_token: '123')
      expect(response.status).to eq 401
    end      
  end

end

shared_examples_for 'API success' do
  it 'returns 200 status code' do
    expect(response).to be_success
  end
end