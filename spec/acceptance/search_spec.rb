require_relative 'sphinx_helper'

feature 'search anything', %q{
  In order to find a need information,
  As an anyone ,
  I want to be search anything
} do

  let(:user) { create(:user, email: "aaa@mail.ru") }
  let!(:something) { create(:question, body: 'abracadabra', title: 'sdfsdfsdfsdfsfdsdfdf', user: user) }
  let!(:questions) { create_list(:question, 2,  user: user) }
  let!(:answer) { create(:answer, question: something, content: 'abracadabra 12',  user: user) }

  before do
    ThinkingSphinx::Test.index
  end

  scenario 'user try to search question' do
    visit root_path
    fill_in 'q', with: 'sdfsdfsdfsdfsfdsdfdf'
    select('Question', from: 'a')
    click_on 'Search'
    expect(page).to have_content something.title
  end

  scenario 'user try to search everywere' do
    visit root_path
    fill_in 'q', with: 'abracadabra'
    select('Everywhere', from: 'a')
    click_on 'Search'
    expect(page).to have_content something.title
    expect(page).to have_content answer.content
  end

  scenario 'user try to search answer' do
    visit root_path
    fill_in 'q', with: 'abracadabra'
    select('Answer', from: 'a')
    click_on 'Search'
    expect(page).to_not have_content something.title
    expect(page).to have_content answer.content
  end

  scenario 'user try to search user' do
    visit root_path
    fill_in 'q', with: 'aaa@mail.ru'
    select('User', from: 'a')
    click_on 'Search'
    expect(page).to have_content user.email
  end
end