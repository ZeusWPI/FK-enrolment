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
    f.inputs do
      # Reset-field: if a club has no fields, extra attributes should be cleared
      f.input(name, :as => :hidden, :value => nil)
    end +
    f.inputs(:for => name) do |f|
      unless f.object.spec.field_type?
        content_tag :li, f.object.spec.name
      else
        f.input(:spec_id, :as => :hidden) +
        field_for_extra_attribute_type(f, f.object.spec.field_type)
      end
    end
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
    when "checkbox_grid"
      f.input :value , :as => :check_boxes, :hidden_fields => true,
        :label => label, :collection => values,
        :wrapper_html => { :class => "checkbox-grid no-indent" }
    when "checkbox_list"
      f.input :value , :as => :check_boxes, :hidden_fields => true,
        :label => label, :collection => values,
        :wrapper_html => { :class => "no-indent" }
    when "study"
      values = Hash[values.map {|e| [e, e]}].merge("Andere" => "")
      f.input(:value, :as => :select, :label => label,
        :collection => values, :wrapper_html => { :class => "study-field" }) +
      content_tag(:li, f.text_field(:value, :size => 20),
        :class => "study-field-other")
    when "text"
      f.input :value, :label => label, :input_html => { :size => 60 } ,
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
