require_relative 'sphinx_helper'

feature 'search anything', %q{
  In order to find a need information,
  As an anyone ,
  I want to be search anything
} do

  let(:user) { create(:user) }
  let!(:something) { create(:question, body: 'abracadabra', title: 'sdfsdfsdfsdfsfdsdfdf', user: user) }
  let!(:questions) { create_list(:question, 2,  user: user) }

  before do
    ThinkingSphinx::Test.index
  end

  scenario 'user try to search' do
    visit root_path
    fill_in 'q', with: 'sdfsdfsdfsdfsfdsdfdf'
    select('Question', from: 'a')
    click_on 'Search'
    expect(page).to have_content something.title
  end
end