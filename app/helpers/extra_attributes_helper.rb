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
    f.inputs :for => name do |f|
      unless f.object.spec.field_type?
        content_tag :li, f.object.spec.name
      else
        f.input(:spec_id, :as => :hidden) +
        render(:partial => "form/" + f.object.spec.field_type, :locals => {:f => f})
      end
    end
  end
end
