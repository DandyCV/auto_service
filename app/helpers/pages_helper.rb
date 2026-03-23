module PagesHelper
  def services_catalog
    translated_collection("pages.shared.services_catalog").map do |service|
      service.merge(icon: service.fetch(:icon).to_sym)
    end
  end

  def shop_benefits
    translated_collection("pages.shared.shop_benefits")
  end

  def work_process_steps
    translated_collection("pages.shared.work_process_steps")
  end

  def testimonials_feed
    translated_collection("pages.shared.testimonials_feed")
  end

  def contact_details
    translated_collection("pages.shared.contact_details")
  end

  def workshop_map_embed_url
    t("pages.shared.map.embed_url")
  end

  def workshop_map_link
    t("pages.shared.map.google_maps_url")
  end

  def workshop_waze_link
    t("pages.shared.map.waze_url")
  end

  def service_icon(icon_name)
    content_tag(:span, class: "service-card__icon", aria: { hidden: true }) do
      image_tag("services/#{icon_name}.png", alt: "", class: "service-card__icon-image")
    end
  end

  private

  def translated_collection(key)
    Array.wrap(I18n.t(key)).map do |entry|
      entry.respond_to?(:deep_symbolize_keys) ? entry.deep_symbolize_keys : entry
    end
  end
end
