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

  def admin_email
    ENV.fetch("ADMIN_EMAIL", "admin")
  end

  def admin_password
    ENV.fetch("ADMIN_PASSWORD", "test1234")
  end

  def authenticate_admin(email, password)
    ActiveSupport::SecurityUtils.secure_compare(email.to_s, admin_email) &&
      ActiveSupport::SecurityUtils.secure_compare(password.to_s, admin_password)
  rescue ArgumentError
    false
  end
end
