module Api
  module V1
    class FriendsController < ApiV1Controller

      def search
        limit = params[:limit] || 30
        offset = params[:offset] || 0

        authentication = current_user.authentications.first

        if authentication
          begin
            graph = Koala::Facebook::GraphAPI.new(authentication.oauth_token)
            fb_friends = graph.get_connections("me", "friends").sort_by{ |u| u["name"] }
            @existing_users = User.joins(:authentications).where("authentications.uid in (?)", fb_friends.map{ |h| h["id"] }).order(:first_name).limit(limit).offset(offset)
          rescue
            render json: { message: "Token de Facebook Invalido" }, status: 400
          end
        else
          render json: { message: "El usuario no tiene una cuenta de facebook asociada." }, status: 400
        end
      end

      # def invite
      #   if current_user.authentications.first
      #     begin
      #       graph = Koala::Facebook::GraphAPI.new(current_user.authentications.first.oauth_token)
      #       fb_friends = graph.get_connections("me", "taggable_friends").sort_by{ |u| u["name"] }
      #       render json: fb_friends
      #     rescue Exception => e
      #       render json: { message: e.message }
      #     end
      #   else
      #     render json: { message: "The user doesn't have a facebook account" }
      #   end
      # end

    end
  end
end
