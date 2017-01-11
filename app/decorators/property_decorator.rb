class PropertyDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end


  def ps_show_field_or_hide_if_empty(field_name, field_val, show_condition)
    ps_show_field_or_show_unknown(field_name, 
      field_val, show_condition) if show_condition
  end
  
  
  def ps_show_field_or_show_unknown(field_name, field_val, show_condition)
    
    markup = "<div class='hanging-indent'>	" +
  	  "<span class='ps-details-titles'>" + field_name + ": </span>"

    if (show_condition)
      (markup + field_val + "</div>").html_safe
    else
      (markup + "Unknown" + "</div>").html_safe
    end
  end
  
end
