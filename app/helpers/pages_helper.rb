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
    paths = {
      diagnostics: [
        tag.circle(cx: "12", cy: "12", r: "3.5"),
        tag.path(d: "M12 2.75v2.1M12 19.15v2.1M21.25 12h-2.1M4.85 12h-2.1M18.54 5.46l-1.48 1.48M6.94 17.06l-1.48 1.48M18.54 18.54l-1.48-1.48M6.94 6.94 5.46 5.46")
      ],
      maintenance: [
        tag.path(d: "M14.9 4.6a4.4 4.4 0 0 0 4.5 5.5L11 18.5 5.5 13l8.4-8.4a4.4 4.4 0 0 0 1 0z"),
        tag.circle(cx: "7.25", cy: "16.75", r: "1.25")
      ],
      brakes: [
        tag.path(d: "M9 4.75h6"),
        tag.path(d: "M9 19.25h6"),
        tag.path(d: "M10 6.5 14 9.2 10 12l4 2.8-4 2.7"),
        tag.path(d: "M14 6.5 10 9.2 14 12l-4 2.8 4 2.7")
      ],
      engine: [
        tag.path(d: "M5 9.5h2.5l1.5-2h5l1.5 2H19v7h-2.5l-1.5 1.75h-6L7.5 16.5H5z"),
        tag.path(d: "M10.25 12h3.5M12 10.25v3.5")
      ],
      electrical: [
        tag.path(d: "M13.5 2.75 6.75 13h4.35L10.5 21.25 17.25 11h-4.35z")
      ],
      tire: [
        tag.circle(cx: "12", cy: "12", r: "7"),
        tag.circle(cx: "12", cy: "12", r: "4"),
        tag.circle(cx: "12", cy: "12", r: "1.35"),
        tag.path(d: "M12 5v3M12 16v3M5 12h3M16 12h3M7.35 7.35l2.15 2.15M14.5 14.5l2.15 2.15M16.65 7.35 14.5 9.5M9.5 14.5l-2.15 2.15")
      ]
    }

    content_tag(:span, class: "service-card__icon", aria: { hidden: true }) do
      content_tag(
        :svg,
        safe_join(paths.fetch(icon_name)),
        viewBox: "0 0 24 24",
        fill: "none",
        xmlns: "http://www.w3.org/2000/svg",
        class: "service-card__icon-svg"
      )
    end
  end

  private

  def translated_collection(key)
    Array.wrap(I18n.t(key)).map do |entry|
      entry.respond_to?(:deep_symbolize_keys) ? entry.deep_symbolize_keys : entry
    end
  end
end
