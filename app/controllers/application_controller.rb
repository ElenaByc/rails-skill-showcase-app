class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def require_login
    return if logged_in?

    respond_to do |format|
      format.json { head :forbidden }
      format.any do
        flash[:alert] = "Please log in to access this page."
        redirect_to root_path
      end
    end
  end
end
