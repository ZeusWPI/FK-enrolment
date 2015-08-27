# encoding: utf-8
module ApplicationHelper
  # Set the application title tag and return a <h2>title</h2>
  def title(page_title)
    content_for(:title, "#{page_title.to_s} – FaculteitenKonvent Gent")
    content_for(:main_title, content_tag(:h2, page_title))
  end

  # Generate a class to be applied to the page body for css scoping
  def generate_body_class
    c = controller.controller_path.split('/').each { |c| c.parameterize.dasherize }
    c.join(' ') + ' ' + controller.action_name.parameterize.dasherize
  end

  # Check if the user has an active CAS authentication
  def cas_authed?
    !session[:cas_user].blank?
  end

  # Check if user has an active eID authentication
  def eid_authed?
    !session[:eid].blank?
  end
end
