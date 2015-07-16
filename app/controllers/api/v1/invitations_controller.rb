module Api
  module V1
    class InvitationsController < ApiV1Controller
      def approve
        invitation = Invitation.where(:event_id => params[:event_id], :user_id => params[:user_id]).first
        if invitation.update_attributes(state: params[:state])
            render json: { success: true }
          else
            render json: { success: false, message: 'Hubo un problema'}, status: 400
          end
      end

      def pending
        numPending = Invitation.numPending(params[:user_id])
        render json: { success: true, count: numPending }, status: 200
      end

    end
  end
end
