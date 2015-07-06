Jbuilder.encode do
  json.array! @photos do |photo|
    begin
    json.partial! "photo", photo: photo
    rescue;end
  end
end