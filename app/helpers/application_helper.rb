module ApplicationHelper
  def nav_link_to(name, path, **options)
    classes = [ "site-nav__link", options[:class] ].compact
    classes << "is-active" if current_page?(path)

    link_to name, path, **options.merge(class: classes.join(" "))
  end
end
