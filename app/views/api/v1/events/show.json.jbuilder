Jbuilder.encode do
  json.partial! "api/v1/events/event", event: @event
  json.photos do
    json.array!(@event.photos) do |photo|
      begin
      json.partial! "api/v1/photos/photo", photo: photo
      rescue;end
    end
  end
  
end