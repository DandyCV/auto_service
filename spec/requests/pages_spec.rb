require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    it "renders the home page" do
      get root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Honest auto service for the cars you rely on every day.")
      expect(response.body).to include("Request Service")
      expect(response.body).to include("request-service-modal")
      expect(response.body).to include('data-modal-open="request-service-modal"')
    end
  end

  describe "GET /about" do
    it "renders the about page" do
      get about_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("About The Workshop")
    end
  end

  describe "GET /services" do
    it "renders the services page" do
      get services_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Everyday repair and maintenance for the cars people depend on most.")
    end
  end

  describe "GET /contacts" do
    it "renders the contacts page" do
      get contacts_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Customers should know how to reach the shop in seconds.")
      expect(response.body).to include("Open the repair request form as a focused pop-up.")
      expect(response.body).to include('data-modal-open="request-service-modal"')
    end
  end

  describe "GET /privacy" do
    it "renders the privacy page" do
      get privacy_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("A launch-ready privacy page still needs real business and legal details.")
    end
  end
end
