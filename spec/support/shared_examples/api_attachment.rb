shared_examples_for 'API Attachments' do
  context 'attachments' do
    it 'included in question object' do
      expect(response.body).to have_json_size(2).at_path("attachments")
    end

    it "Attachments object contains url" do
      expect(response.body).to be_json_eql(attachments.first.file.url.to_json).at_path("attachments/0/url")
    end
  end 
end 
