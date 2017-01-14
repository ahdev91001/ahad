module Views::Properties::ShowHelper

  def ps_markup_field_or_hide(name, value, hide=false, 
                              ext_field=nil, ext_conf_val=nil,
                              ext_true_str=nil, ext_false_str=nil
                              )
    title = "<div class='hanging-indent'> " +
       "<span class='ps-details-titles'> #{name}: </span>"
       
    conf_str = ""
    if (ext_conf_val != nil)
      conf_str = ext_false_str
      if (ext_field != nil && ext_field.upcase == ext_conf_val)
          conf_str = ext_true_str
      end
    end
    
    if (value != nil)
      (title + value + conf_str + "\n</div>").html_safe
    else
      (title + "Unknown\n</div>").html_safe unless hide
    end
  end
end

