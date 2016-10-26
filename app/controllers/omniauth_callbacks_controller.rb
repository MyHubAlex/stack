class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oath(request.env['omniauth.auth']) 
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :succes, kind: 'Facebook') if is_navigational_format?
    end  
  end

  def twitter
    auth = request.env["omniauth.auth"]
    @user = User.find_for_oath(request.env['omniauth.auth']) 
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :succes, kind: 'Twitter') if is_navigational_format?
    else
      session['devise.omniauth_data'] = {provider: auth.provider, uid: auth.uid.to_s}
      render action: :confirm_email, user: @user
    end        
  end
end