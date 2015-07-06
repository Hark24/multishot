module Api
  module V1
    class PhotosController < ApiV1Controller
      before_action :set_image, only: [:destroy]

      def index
        @photos = Photo.all
      end

      def create
        @photo = Photo.new(photo_params)
        if @photo.event.active
          if @photo.save
            render json: { success: true, message: "La foto fue subida correctamente" }
          else
            render json: { success: false, message: "Hubo un problema al subir la foto" }, status: 400
          end
        else
          render json: { success: false, message: "Este evento no esta activado." }, status: 400
        end
      end

      def destroy
        if @photo.destroy
          render json: { success: true, message: "La foto ha sido eliminada correctamente" }
        else
          render json: { success: false, message: "Hubo un problema al eliminar la foto" }, status: 400
        end
      end

      private
        def set_photo
          @photo = Photo.find(params[:id])
        end

        def photo_params
          params.permit(:event_id, :images, :user_id, :taked_at)
        end
    end
  end
end