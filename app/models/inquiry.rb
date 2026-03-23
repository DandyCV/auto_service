class Inquiry < ApplicationRecord
  INQUIRY_TYPES = [
    "Brake Systems",
    "Steering and Suspension Repair",
    "Tire Services",
    "Oil Changes & Fluid Checks",
    "Engine Diagnostics",
    "Air and Cabin Filter Replacement",
    "Battery and Auto Electrical",
    "Bodywork and Trim",
    "Exhaust Systems",
    "Gearbox and Transmission Repair",
    "Wheel Alignment",
    "Pre-NCT Check",
    "Other"
  ].freeze

  validates :name, presence: true, length: { maximum: 80 }
  validates :phone, presence: true, length: { maximum: 30 }
  validates :comment, length: { maximum: 1_000 }, allow_blank: true
  validates :inquiry_type, inclusion: { in: INQUIRY_TYPES }, allow_blank: true

  before_validation :normalize_phone
  before_validation :normalize_comment

  private

  def normalize_phone
    self.phone = phone.to_s.gsub(/[^\d+\-\s()]/, "").squish
  end

  def normalize_comment
    self.comment = comment.to_s
  end
end
