module Api
  module V1
    class ContactsController < ApiV1Controller
      
      def create
        @contact = Contact.new(contact_params)
        if @contact.save
          render json: { success: true, message: "La foto fue subida correctamente" }
        else
          render json: { success: false, message: "Hubo un problema al subir la foto" }, status: 400
        end
      end

      def add
        contacts = []
        error = false
        values = JSON.parse(params[:users])
        values.each do |user_id|
          if user_id != params[:user_id].to_i
            new_contact = Contact.new(user_1_id: params[:user_id], user_2_id: user_id)
            new_contact_2 = Contact.new(user_2_id: params[:user_id], user_1_id: user_id)
            contacts << new_contact
            contacts << new_contact_2 
          end
        end

        Contact.transaction do
          success = contacts.map(&:save)
          unless success.all?
            error = true
            raise ActiveRecord::Rollback
          end
        end

        unless  error
          render json: { success: true, message: "Se ha agregado correctamente a sus contactos" }
        else
          render json: { success: false, message: "Hubo un problema al agregar contactos" }, status: 400
        end
      end

      private
        def contact_params
          params.permit(:user_1_id, :user_2_id)
        end
    end
  end
end
