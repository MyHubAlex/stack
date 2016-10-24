require_relative 'acceptance_helper'

feature 'sign in via twitter account', %q{
  In order to come in site,
  As an user,
  I want to be sign in via twitter
} do

  scenario 'sign in via twitter account' do
    visit new_user_session_path
    #save_and_open_page
    mock_auth_hash
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
    
    expect(page).to have_content("Sign in with Twitter")     
    click_on "Sign in with Twitter"
    #save_and_open_page 
    expect(page).to have_content 'Please confirm your email address after continue.'
    
    fill_in 'Email', with: 'test@test.com' 
    click_on('Continue')
    open_email('test@test.com')
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'
     
  end

end