module Api
  module V1
    class PhotosController < ApiV1Controller
      before_action :set_image, only: [:destroy]

      def index
        @photos = Photo.all
      end

      def create
        @photo = Photo.new(photo_params)
        if @photo.save
          render json: { success: true, message: "La foto fue subida correctamente" }
        else
          render json: { success: false, message: "Hubo un problema al subir la foto" }, status: 400
        end
      end

      def destroy
        if @photo.destroy
          render json: { success: true, message: "La foto ha sido eliminada correctamente" }
        else
          render json: { success: false, message: "Hubo un problema al eliminar la foto" }, status: 400
        end
      end

      def event_photos
        margin = 10
        lista = []
        @photos = []
        all_photos = Photo.where(event_id: params[:event_id])
        first_photo = all_photos.first
        all_photos.each do |photo|
          if photo.taked_at >= first_photo.taked_at and photo.taked_at < first_photo.taked_at + 60 * margin
            lista << photo
          else
            @photos << lista
            first_photo = photo
            lista = []
            lista << photo
          end
        end
        @photos << lista
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