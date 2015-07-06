Jbuilder.encode do
  json.partial! "api/v1/users/basic_user_info", user: @user
  json.email @user.email
  json.token @user.token
  json.accept_terms @user.accept_terms
  json.authentications do
    json.array!(@user.authentications) do |auth|
      json.provider auth.provider
      json.uid auth.uid
      json.oauth_token auth.oauth_token
    end
  end
end
