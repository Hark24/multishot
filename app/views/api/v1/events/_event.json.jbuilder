json.partial! "api/v1/events/basic_event_info", event: event
json.numPhotos        event.photos.size
json.numUsers         event.invitations.where(:state => 1).size
json.author           event.user.authorEvent
json.imageURL         event.user.avatar