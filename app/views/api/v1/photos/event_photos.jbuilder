Jbuilder.encode do
  json.empty  @photos[0].empty?
  json.photos do
    json.array! @photos do |listas|
      begin
      json.array! listas do |photo|
      	json.partial! "photo", photo: photo
      end
      rescue;end
    end
  end
end