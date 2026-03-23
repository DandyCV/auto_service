class InquiriesController < ApplicationController
  def create
    @inquiry = Inquiry.new(inquiry_params)
    @return_to = safe_return_to

    if @inquiry.save
      TelegramNotifier.new.notify_new_inquiry(@inquiry)

      respond_to do |format|
        format.turbo_stream
        format.html do
          redirect_to @return_to, notice: "Your request was sent. We will contact you shortly."
        end
      end
    else
      respond_to do |format|
        format.turbo_stream { render :create, status: :unprocessable_content }
        format.html do
          render page_template_for(@return_to), status: :unprocessable_content
        end
      end
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :phone, :inquiry_type, :comment)
  end

  def safe_return_to
    allowed_paths = [
      root_path(anchor: "request"),
      contacts_path(anchor: "request")
    ]

    allowed_paths.include?(params[:return_to]) ? params[:return_to] : contacts_path(anchor: "request")
  end

  def page_template_for(return_to)
    return_to.start_with?(root_path) ? "pages/home" : "pages/contacts"
  end
end
