require "rails_helper"

RSpec.describe "Admin inquiries", type: :request do
  around do |example|
    original_email = ENV["ADMIN_EMAIL"]
    original_password = ENV["ADMIN_PASSWORD"]

    ENV["ADMIN_EMAIL"] = "admin@example.ie"
    ENV["ADMIN_PASSWORD"] = "secret-pass"
    example.run
  ensure
    ENV["ADMIN_EMAIL"] = original_email
    ENV["ADMIN_PASSWORD"] = original_password
  end

  let!(:older_inquiry) do
    Inquiry.create!(
      name: "Niamh Doyle",
      phone: "+353 87 111 2233",
      inquiry_type: "Maintenance",
      comment: "Needs an oil service next week.",
      created_at: 2.days.ago
    )
  end

  let!(:latest_inquiry) do
    Inquiry.create!(
      name: "Cian Murphy",
      phone: "+353 86 555 7788",
      inquiry_type: "Diagnostics",
      comment: "Engine light came on this morning.",
      created_at: 1.day.ago
    )
  end

  before do
    post admin_session_path, params: { email: "admin@example.ie", password: "secret-pass" }
  end

  it "renders the inquiries index with the latest requests first" do
    get admin_inquiries_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("All service requests in one place.")
    expect(response.body.index("Cian Murphy")).to be < response.body.index("Niamh Doyle")
  end

  it "paginates the requests with 20 items per page" do
    21.times do |index|
      Inquiry.create!(
        name: "Customer #{index}",
        phone: "+353 85 000 #{format('%04d', index)}",
        inquiry_type: "Other",
        comment: "Follow-up request #{index}.",
        created_at: index.minutes.ago
      )
    end

    get admin_inquiries_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Page 1 of 2")
    expect(response.body).to include("Next")
    expect(response.body).to include("Customer 0")
    expect(response.body).not_to include("Niamh Doyle")

    get admin_inquiries_path(page: 2)

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Page 2 of 2")
    expect(response.body).to include("Previous")
    expect(response.body).to include("Niamh Doyle")
  end

  it "filters by id, name, phone, service type, and issue text" do
    targeted_inquiry = Inquiry.create!(
      name: "Aoife Brennan",
      phone: "+353 85 432 1098",
      inquiry_type: "Electrical",
      comment: "Intermittent battery drain after parking overnight."
    )

    get admin_inquiries_path(
      id: targeted_inquiry.id,
      name: "Aoife",
      phone: "432",
      inquiry_type: "Electrical",
      issue: "battery drain"
    )

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Aoife Brennan")
    expect(response.body).to include("+353 85 432 1098")
    expect(response.body).to include("Electrical")
    expect(response.body).not_to include("Cian Murphy")
    expect(response.body).not_to include("Niamh Doyle")
  end

  it "preserves filters in pagination links" do
    21.times do |index|
      Inquiry.create!(
        name: "Brake Customer #{index}",
        phone: "+353 85 300 #{format('%04d', index)}",
        inquiry_type: "Brake Service",
        comment: "Brake issue #{index}.",
        created_at: index.minutes.ago
      )
    end

    get admin_inquiries_path(inquiry_type: "Brake Service")

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Page 1 of 2")
    expect(response.body).to include("inquiry_type=Brake+Service&amp;page=2")
  end

  it "renders the edit page" do
    get edit_admin_inquiry_path(latest_inquiry)

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Update request ##{latest_inquiry.id}")
  end

  it "updates an inquiry without deleting it" do
    patch admin_inquiry_path(latest_inquiry), params: {
      inquiry: {
        name: "Cian Murphy",
        phone: "+353 86 555 7788",
        inquiry_type: "Diagnostics",
        comment: "Booked for a full warning-light inspection."
      }
    }

    expect(response).to redirect_to(admin_inquiries_path)
    expect(latest_inquiry.reload.comment).to eq("Booked for a full warning-light inspection.")
  end

  it "deletes an inquiry" do
    expect do
      delete admin_inquiry_path(latest_inquiry)
    end.to change(Inquiry, :count).by(-1)

    expect(response).to redirect_to(admin_inquiries_path)
    follow_redirect!
    expect(response.body).to include("Request deleted successfully.")
  end
end
