module Api
  module V1
    class EventsController < ApiV1Controller
      before_action :set_event, only: [:show]
      def index
        @events = Event.join_invitations.find_for_state(params[:state], params[:user_id])
      end

      def create
        current_user = User.find(params[:user_id])
        @event = Event.new(event_params)
        @users = current_user.users

        @event.invitations.new(user_id: params[:user_id], state: 1)
        if @event.permission.eql?("public")
          @users.each do |user|
            @event.send_invitations(user.id)
          end
        else
          contacts = JSON.parse(params[:contacts])
          contacts.each do |contact_id|
            if(contact_id != user.id)
              @event.send_invitations(contact_id)
            end
          end
        end

        if @event.save
          render json: { success: true, event_id: @event.id }, status: 200
        else
          render json: { success: false, message: "Hubo un problema al crear el evento"}, status: 400
        end
      end

      def show
        # if @event.nil?
        #   render json: { success: false, message: "No existe el evento"}, status: 404
        # end
      end

      # def changeActive
      #   @event = Event.find(params[:event_id])
      #   if params[:active]
      #     author_id = @event.user_id
      #     other_events = Event.where("user_id = ? and id <> ? ", author_id, params[:event_id])
      #     other_events.update_all(active: false)
      #   end
      #   @event.active = params[:active]
      #   @event.save
      #   render json: { success: true }, status: 200
      # end

      def search
        invitations_events = Event.join_invitations.search_event_name(params[:q])
        type = params[:type]
        if type.eql?("0") or type.eql?("1")
          @events = invitations_events.find_for_state(type, params[:user_id])
        else
          text = "%#{params[:q]}%"
          @events = Event.find_to_active(text, params[:user_id])
        end
        render "api/v1/events/index"
      end

      private
        def set_event
          @event = Event.find(params[:id])
        end

        def event_params
          params.permit(:name, :active, :permission, :user_id)
        end

    end
  end
end