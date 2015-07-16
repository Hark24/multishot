module Api
  module V1
    class AuthenticationsController < ApiV1Controller

      def create
        current_user.authentications.create(params[:authentication].permit!)
        render json: { success: true }
      end

    end
  end
end
