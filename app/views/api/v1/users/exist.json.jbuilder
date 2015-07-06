Jbuilder.encode do
  json.user_exists  @exist
  json.fb_id  @fb_id
  json.message  @message
end