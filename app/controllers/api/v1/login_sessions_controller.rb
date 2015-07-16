module Api
  module V1
    class LoginSessionsController < ApiV1Controller

      def create
        @user = User.find_by_email(params[:email])
        if @user
          if @user.invalid_password(params[:password])
            render json: { message: "Password incorrecto." }, status: 400
            return
          end

          @user.confirm_account

          render "api/v1/me/show"
        end
      end

    end
  end
end
