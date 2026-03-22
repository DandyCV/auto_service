class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :admin_signed_in?

  private

  def admin_signed_in?
    session[:admin_signed_in] == true
  end

  def require_admin!
    return if admin_signed_in?

    redirect_to new_admin_session_path, alert: "Please sign in as an administrator."
  end

  def admin_user
    ENV.fetch("ADMIN_USER")
  end

  def admin_password
    ENV.fetch("ADMIN_PASSWORD")
  end

  def authenticate_admin(user, password)
    ActiveSupport::SecurityUtils.secure_compare(user.to_s, admin_user) &&
      ActiveSupport::SecurityUtils.secure_compare(password.to_s, admin_password)
  rescue ArgumentError
    false
  end
end
