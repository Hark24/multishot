Rails.application.config.middleware.use OmniAuth::Builder do

  # Development
    provider :facebook, FACEBOOK_CONFIG['app_id'], FACEBOOK_CONFIG['secret'],
            scope: "email,user_birthday,publish_actions,user_friends",
            image_size: { width: 300, height: 300 }

  # Production
    # provider :facebook, "180988378747978", "b4acd46e81ed379df07787c4376edf16",
    #         scope: "email,user_birthday,publish_actions,user_friends",
    #         image_size: { width: 300, height: 300 }
end
