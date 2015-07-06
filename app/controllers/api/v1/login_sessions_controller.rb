module Api
  module V1
    class LoginSessionsController < ApiV1Controller
      
      def create
        @user = User.find_by_email(params[:email])
        if @user 
          authentication = @user.authentications.first
          if !@user.password_digest.blank? && !@user.authenticate(params[:password]) && authentication.nil?
            render json: { message: "Password incorrecto." }, status: 400
            return
          end

          if !@user.confirmed
            @user.confirm_account
          end
          render template: "api/v1/me/show"
        end
      end
      
    end
  end
end
