# encoding: utf-8
module ApplicationHelper
  def title(page_title)
    content_for(:title, "#{page_title.to_s} – FaculteitenKonvent Gent")
    content_tag(:h2, page_title)
  end

  def generate_body_class
    c = controller.controller_name.parameterize.dasherize
    a = controller.action_name.parameterize.dasherize
    "#{c} #{c}-#{a}"
  end
end
