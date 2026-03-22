module Admin
  class SessionsController < ApplicationController
    layout "admin"

    def new
      redirect_to admin_inquiries_path if admin_signed_in?
    end

    def create
      if authenticate_admin(params[:user], params[:password])
        session[:admin_signed_in] = true
        redirect_to admin_inquiries_path, notice: "Signed in successfully."
      else
        flash.now[:alert] = "Invalid login or password."
        render :new, status: :unprocessable_content
      end
    end

    def destroy
      reset_session
      redirect_to new_admin_session_path, notice: "Signed out successfully."
    end
  end
end
