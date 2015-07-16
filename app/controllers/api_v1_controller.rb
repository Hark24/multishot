class ApiV1Controller < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :verify_current_user
  skip_before_filter :verify_authenticity_token
  helper_method :current_user

  def verify_current_user
    token = request.headers["HTTP_AUTHORIZATION"] ? request.headers["HTTP_AUTHORIZATION"].split("\"")[1] : params[:token]
    if token
      @current_user ||= User.find_by_token(token)
      if @current_user.nil?
        render json: { error: "No esta autorizado para realizar esta accion." }, status: 401
      end
    end
    return
  end

  private
    def current_user
      @current_user
    end

end
