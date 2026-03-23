require "rails_helper"

RSpec.describe Inquiry, type: :model do
  subject(:inquiry) do
    described_class.new(
      name: "Alex Johnson",
      phone: "+1 (555) 111-2233",
      inquiry_type: "Engine Diagnostics",
      comment: "Engine light is on and the car shakes at idle."
    )
  end

  it "is valid with the required attributes" do
    expect(inquiry).to be_valid
  end

  it "requires a name" do
    inquiry.name = ""

    expect(inquiry).not_to be_valid
    expect(inquiry.errors[:name]).to include("can't be blank")
  end

  it "requires a phone number" do
    inquiry.phone = ""

    expect(inquiry).not_to be_valid
    expect(inquiry.errors[:phone]).to include("can't be blank")
  end

  it "allows a blank comment" do
    inquiry.comment = ""

    expect(inquiry).to be_valid
  end

  it "converts a nil comment to an empty string" do
    inquiry.comment = nil
    inquiry.validate

    expect(inquiry.comment).to eq("")
  end

  it "normalizes the phone before validation" do
    inquiry.phone = " +1 (555) 111-2233 ext. 9 "
    inquiry.validate

    expect(inquiry.phone).to eq("+1 (555) 111-2233 9")
  end

  it "persists an empty string comment instead of null" do
    inquiry.comment = nil
    inquiry.save!

    expect(inquiry.reload.comment).to eq("")
  end
end
