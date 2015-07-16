module Api
  module V1
    class UsersController < ApiV1Controller

      def create
        email = params[:user][:email]
        unless email.blank?
          user = User.where(email: email).first_or_initialize
          user.assign_attributes(user_params)
          authentication = params[:authentication]

          if authentication
            account = Authentication.where(authentication.permit(:provider, :uid)).first_or_initialize
            # new_friend = true if account.oauth_token.blank?
            account.set_oauth_token(authentication)
            user.assign_attributes(fb_user_params)
            user.avatar = "https://graph.facebook.com/#{account.uid}/picture?type=large"
          end

          if user.valid?
            user.save
            user.send_welcome_email unless authentication
            if account
              account.save_data(user.id)
              # if new_friend
              #   user.subscriptions.create(subscribable_type: "Activities::NewFBFriend", subscribable_id: 1)
              # end
              # @account = account
            end
            # @user = user
            render json: { success: true }, status: 200
          else
            Rails.logger.info user.errors.inspect
            render json: { message: user.errors.full_messages.first }, status: 400
          end
        else
          render json: { message: "El correo no puede estar en blanco." }, status: 400
        end
      end

      def accept_terms_conditions
      	user = User.find(params[:id])
      	user.accept_terms_and_conditions
        # relacion muchos a mucho usuarios
        # asignar amigos de fb dentro de la app al usuario
        user.save_contacts
      	render json: { success: true }, status: 200
      end

      def exist
        email = params[:email] || ""
        unless email.blank?
          user = User.find_by_email(email)
          @exist = !user.nil?
          if @exist
            if !user.authentications.first.nil?
              @fb_id = user.authentications.first.uid
            end
          end
        else
          render json: { message: "El correo no puede estar en blanco." }, status: 400
        end
      end

      def search
        text = "%#{params[:q]}%"
        @current_user = User.find(params[:user_id])
        if params[:type] == "0"
          @users = User.find_user(text, params[:user_id])
        else
          @users = @current_user.users.find_text(text)
        end
        render "api/v1/contacts/index"
      end

      private
        def user_params
          params.permit(:email)
        end

        def fb_user_params
          params[:user].permit(:first_name, :last_name, :email, :avatar)
        end

    end
  end
end
