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


  def ps_show_field_or_hide_if_empty(prehtml, posthtml, field_name, 
    field_val, show_condition)
    
    ps_show_field_or_show_unknown(prehtml, posthtml, 
      field_name, field_val, show_condition) if show_condition
      
  end
  
  
  def ps_show_field_or_show_unknown(prehtml, posthtml, field_name, 
    field_val, show_condition)
    
    pre_subbed = prehtml.gsub(/%%FIELD_NAME%%/, field_name)

    if (show_condition)
      (pre_subbed + field_val + posthtml).html_safe
    else
      (pre_subbed + "Unknown" + posthtml).html_safe
    end
  end

  def ps_show_year_built(prehtml, posthtml, field_name, 
    field_val, confirm_field, show_condition)

    ps_show_field_or_show_unknown_w_confirmed_2(prehtml, posthtml, 
      field_name, field_val, confirm_field, show_condition,
      "A", " (actual)", " (estimated)")
    
  end

  def ps_show_field_or_show_unknown_w_confirmed(prehtml, posthtml, field_name, 
    field_val, confirm_field, show_condition)
    
    ps_show_field_or_show_unknown_w_confirmed_2(prehtml, posthtml, 
      field_name, field_val, confirm_field, show_condition,
      "Y", " (confirmed)", " (unconfirmed)")
      
  end
  
  def ps_show_field_or_show_unknown_w_confirmed_2(prehtml, posthtml, 
    field_name, field_val, confirm_field, show_condition,
    match_letter, match_string_true, match_string_false)
  
    pre_subbed = prehtml.gsub(/%%FIELD_NAME%%/, field_name)
    
    if (show_condition)
      if (confirm_field != nil && confirm_field.upcase == match_letter)
        (pre_subbed + field_val + match_string_true + posthtml).html_safe
      else
        (pre_subbed + field_val + match_string_false + posthtml).html_safe
      end
    else
        (pre_subbed + "Unknown" + posthtml).html_safe
    end
  end # ps_show_field_or_show_unknown_w_confirmed
  
end
