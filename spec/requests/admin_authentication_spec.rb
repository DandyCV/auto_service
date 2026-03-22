require "rails_helper"

RSpec.describe "Admin authentication", type: :request do
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

  it "renders the login page" do
    get new_admin_session_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Sign in to manage service requests.")
  end

  it "renders the login page from /admin" do
    get admin_root_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Sign in to manage service requests.")
  end

  it "rejects invalid credentials" do
    post admin_session_path, params: { email: "admin@example.ie", password: "wrong-pass" }

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Invalid email or password.")
  end

  it "signs in with valid credentials" do
    post admin_session_path, params: { email: "admin@example.ie", password: "secret-pass" }

    expect(response).to redirect_to(admin_inquiries_path)
    follow_redirect!
    expect(response.body).to include("Signed in successfully.")
  end

  it "protects the inquiries index from unauthenticated access" do
    get admin_inquiries_path

    expect(response).to redirect_to(new_admin_session_path)
    follow_redirect!
    expect(response.body).to include("Please sign in as an administrator.")
  end
end
