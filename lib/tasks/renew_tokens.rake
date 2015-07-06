namespace :users do
  task renew_tokens: :environment do
	Authentication.where("oauth_token_expires_at < ?", Time.now - 2.day).each do |authentication|
	  begin
	  	authentication.renew_token
	  rescue
	  end
	end
  end
end