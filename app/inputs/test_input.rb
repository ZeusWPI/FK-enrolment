class TestInput < Formtastic::Inputs::SelectInput
  
  def to_html
    input_wrapping do
      label_html <<
      (options[:group_by] ? grouped_select_html : select_html)
    end << 
    hidden_wrapping do
      builder.label(input_name, "andere:", label_html_options) << 
      builder.text_field(method, input_html_options)
    end 
  end

  def hidden_wrapping(&block)
    template.content_tag(:li, 
      [template.capture(&block), error_html, hint_html].join("\n").html_safe, 
      hidden_wrapper_options
    )
  end

  def hidden_wrapper_options
    opts = wrapper_html_options.dup
    opts[:class] << " hidden"
    opts
  end

  def collection
    super << "andere"
  end
end
