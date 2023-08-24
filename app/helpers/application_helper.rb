module ApplicationHelper
  include Pagy::Frontend

  def full_title page_title = ""
    base_title = t("static_pages.full_title")
    if page_title.blank?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end
