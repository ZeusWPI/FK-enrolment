# encoding: utf-8
module ExtraAttributesHelper
  ActiveModel::Errors.class_exec do
    # Generate a list of error messages, with correct names for extra attributes
    def full_messages_with_extra_attributes
      errors = []

      # Default model errors
      each do |attribute, message|
        unless attribute =~ /^extra_attributes\./
          errors << @base.class.human_attribute_name(attribute) + ' ' + message
        end
      end

      # Get the attribute name from the spec for extra attribute errors
      @base.extra_attributes.each do |attribute|
        attribute.errors.each do |_, message|
          errors << attribute.spec.name + ' ' + message
        end
      end

      errors
    end
  end

  # Renders the extra attributes in the (Formtastic) form
  def render_extra_attributes(f, name = :extra_attributes)
    f.inputs(:for => name) do |f|
      unless f.object.spec.field_type?
        content_tag :li, f.object.spec.name
      else
        f.input(:spec_id, :as => :hidden) +
        field_for_extra_attribute_type(f, f.object.spec.field_type)
      end
    end
  end

  # Render extra attribute value
  def render_extra_attribute_value(attribute)
    return if attribute.spec.field_type.blank?

    if attribute.value.is_a? Array
      # Filter out empty values
      attribute.value.delete_if { |v| v.blank? }
    end

    value = case attribute.spec.field_type
    when "checkbox"
      attribute.value == '1' ? icon('check') : icon('remove')
    when "checkbox_grid"
      attribute.value.join(', ')
    when "checkbox_list"
      items = attribute.value.reduce(raw('')) { |acc, v| acc + content_tag(:li, v) }
      content_tag(:ul, items)
    when "dropdown", "study", "text", "textarea", "groupedstudy"
      simple_format(attribute.value)
    else
      raise "Unknown field-type #{attribute.spec.field_type}"
    end

    options = {}
    if %w(checkbox_grid checkbox_list text textarea).include? attribute.spec.field_type
      options[:class] = "block-value"
    end

    content_tag(:dt, "#{attribute.spec.name}:") + content_tag(:dd, value, options)
  end

  private

  # One larger case-statement > a lot of silly erb-files.
  def field_for_extra_attribute_type(f, type)
    label = f.object.spec.name
    values = f.object.spec.values

    case type
    when "checkbox"
      f.input :value , :as => :boolean, :label => label,
        :wrapper_html => { :class => "no-indent" }
    when "checkbox_grid", "checkbox_list"
      classes = "no-indent" + (type == "checkbox_grid" ? " checkbox-grid" : "")
      f.input :value , :as => :check_boxes, :label => label,
        :collection => values, :wrapper_html => { :class => classes }
    when "dropdown"
      f.input(:value, :as => :select, :label => label, :collection => values)
    when "study"
      values = Hash[values.map {|e| [e, e]}].merge("Andere" => "")
      f.input(:value, :as => :select, :label => label,
        :collection => values, :wrapper_html => { :class => "study-field" }) +
      content_tag(:li, f.text_field(:value, :size => 20),
        :class => "study-field-other")
      when "groupedstudy"
        values = values.merge("Andere": []).map { |k,v| [ k, [ k ] + v ]}
      f.input(:value, as: :select, collection: values,  :label => label,  :wrapper_html => { :class => "study-field" }) +
      content_tag(:li, f.text_field(:value, :size => 20),
        :class => "study-field-other")
    when "text"
      f.input :value, as: :string, :label => label, :input_html => { :size => 60 } ,
        :wrapper_html => { :class => "no-indent" }
    when "textarea"
      f.input :value, :as => :text, :label => label,
        :input_html => { :cols => 60, :rows => 5 },
        :wrapper_html => { :class => "no-indent" }
    else
      raise "Unknown field-type #{type}"
    end
  end
end
