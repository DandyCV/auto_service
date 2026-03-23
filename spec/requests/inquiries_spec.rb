require "rails_helper"

RSpec.describe "Inquiries", type: :request do
  describe "POST /inquiries" do
    let(:valid_params) do
      {
        inquiry: {
          name: "Alex Johnson",
          phone: "+1 (555) 014-2867",
          inquiry_type: "Engine Diagnostics",
          comment: "The engine light is on and there is a rough idle."
        }
      }
    end

    before do
      allow_any_instance_of(TelegramNotifier).to receive(:notify_new_inquiry).and_return(true)
    end

    it "creates an inquiry and returns a turbo stream success response" do
      expect do
        post inquiries_path,
          params: valid_params.merge(return_to: contacts_path(anchor: "request"), frame_id: "contacts_inquiry_form"),
          headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }
      end.to change(Inquiry, :count).by(1)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("Request Received")
    end

    it "sends a telegram notification after a successful inquiry" do
      expect_any_instance_of(TelegramNotifier).to receive(:notify_new_inquiry).once

      post inquiries_path,
        params: valid_params.merge(return_to: contacts_path(anchor: "request"), frame_id: "contacts_inquiry_form"),
        headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }
    end

    it "returns validation errors inside the turbo frame" do
      expect do
        post inquiries_path,
          params: {
            inquiry: valid_params[:inquiry].merge(name: "", comment: ""),
            return_to: contacts_path(anchor: "request"),
            frame_id: "contacts_inquiry_form"
          },
          headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }
      end.not_to change(Inquiry, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Please fix the highlighted fields.")
      expect(response.body).to include("Name can&#39;t be blank")
    end

    it "does not send a telegram notification when the inquiry is invalid" do
      expect_any_instance_of(TelegramNotifier).not_to receive(:notify_new_inquiry)

      post inquiries_path,
        params: {
          inquiry: valid_params[:inquiry].merge(name: "", comment: ""),
          return_to: contacts_path(anchor: "request"),
          frame_id: "contacts_inquiry_form"
        },
        headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }
    end

    it "creates an inquiry when the comment is blank" do
      expect do
        post inquiries_path,
          params: {
            inquiry: valid_params[:inquiry].merge(comment: ""),
            return_to: contacts_path(anchor: "request"),
            frame_id: "contacts_inquiry_form"
          },
          headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }
      end.to change(Inquiry, :count).by(1)

      expect(Inquiry.last.comment).to eq("")
      expect(response).to have_http_status(:ok)
    end

    it "redirects back to contacts for standard html requests" do
      post inquiries_path, params: valid_params.merge(return_to: contacts_path(anchor: "request"))

      expect(response).to redirect_to(contacts_path(anchor: "request"))
    end

    it "redirects back to the home page when submitted from the home form" do
      post inquiries_path, params: valid_params.merge(return_to: root_path(anchor: "request"))

      expect(response).to redirect_to(root_path(anchor: "request"))
    end
  end
end
