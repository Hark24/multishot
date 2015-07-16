class Authentication < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider, :oauth_token
  validates_uniqueness_of :uid, scope: :provider
  # after_create :subscribe_new_friend

  # def subscribe_new_friend
  #   if self.user and self.user.is_user?
  #     self.user.subscriptions.create(subscribable_type: "Activities::NewFBFriend", subscribable_id: 1)
  #   end
  # end

  def renew_token
    new_token = Koala::Facebook::OAuth.new("825304844170319", "2df83d392b8dc7c51252d637c6fe3a26").exchange_access_token_info(self.oauth_token)
    self.oauth_token = new_token['access_token']
    self.oauth_token_expires_at = Time.now + new_token['expires'].to_i.seconds
    self.save
  end

  def set_oauth_token authentication
    oauth_token = authentication[:oauth_token]
    oauth_token_expires_at = Time.now + authentication[:oauth_token_expires_at].to_i.seconds
  end

  def save_data user_id
    user_id = user.id
    save
  end
end
