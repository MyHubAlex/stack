module OmniauthMacros

 def mock_auth_hash

     OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      "uid" => "1111",
      "provider" => "twitter",
      "credentials" => {
        "token" => "token",
        "secret" => "secret"
      },
      "info" => {
        
      }
    })
  end 
end