json.partial! "api/v1/users/basic_user_info", user: user
json.email            user.email
json.token            user.token
json.accept_terms     user.accept_terms