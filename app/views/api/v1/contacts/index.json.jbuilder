Jbuilder.encode do
  json.array! @users do |user|
    json.partial! "api/v1/users/user.json", user: user
    json.exist_contact 		 @current_user.verify_contact(user.id)
  end
end