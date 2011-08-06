# encoding: utf-8
module ApplicationHelper
  # Set the application title tag and return a <h2>title</h2>
  def title(page_title)
    content_for(:title, "#{page_title.to_s} – FaculteitenKonvent Gent")
    content_tag(:h2, page_title)
  end

  # Generate a class to be applied to the page body for css scoping
  def generate_body_class
    c = controller.controller_path.split('/').each { |c| c.parameterize.dasherize }
    c.join(' ') + ' ' + controller.action_name.parameterize.dasherize
  end
end
