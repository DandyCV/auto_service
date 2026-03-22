require "rails_helper"

RSpec.describe Admin::InquiriesController, type: :routing do
  it "routes GET /admin/inquiries to index" do
    expect(get: "/admin/inquiries").to route_to("admin/inquiries#index")
  end

  it "routes GET /admin/inquiries/:id/edit to edit" do
    expect(get: "/admin/inquiries/1/edit").to route_to("admin/inquiries#edit", id: "1")
  end

  it "routes PATCH /admin/inquiries/:id to update" do
    expect(patch: "/admin/inquiries/1").to route_to("admin/inquiries#update", id: "1")
  end

  it "routes DELETE /admin/inquiries/:id to destroy" do
    expect(delete: "/admin/inquiries/1").to route_to("admin/inquiries#destroy", id: "1")
  end
end
