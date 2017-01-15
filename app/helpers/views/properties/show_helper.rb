require 'pry-byebug'

module Views::Properties::ShowHelper

  def ps_photo_markup(photo)
    if (@photo != nil && @photo.filename != nil && 
       @photo.filename.length > 0) then 
		    url = "http://altadenaheritagepdb.org/photo/" + @photo.filename
        image_tag(url, :id => "ps-photo-main", 
            :alt => "Photo of Property")
    else
      itag = image_tag('house-stick-figure-med.png',
                  :alt => 'Cartoon Photo of Property')
(%Q{<div id='ps-photo-main-no-photo'>
        #{itag}
        <br>
        We do not have a picture of this house yet.  
        <a href="http://altadenaheritage.org/contact-us/" target="_blank">
        Let us know</a> if you have one!
      </div>}).html_safe
    end 
  end
  
  #
  #
  #
  def ps_markup_apn_or_hide(apn)
    ps_markup_field_or_hide("APN", 
        (apn != nil && apn.parcel != nil) ? apn.parcel : nil)
  end

  #
  #
  #
  def ps_markup_field_or_hide(name, value, hide=false, 
                              ext_field=nil, ext_conf_val=nil,
                              ext_true_str=nil, ext_false_str=nil
                              )
    title = "<div class='hanging-indent'> " +
       "<span class='ps-details-titles'> #{name}: </span>"
       
    conf_str = ""
    if (ext_conf_val != nil)
      conf_str = ext_false_str
      if (ext_field != nil && ext_field.upcase == ext_conf_val.upcase)
          conf_str = ext_true_str
      end
    end

    if (value != nil)
      ("    " + title + value + conf_str + "\n      </div>").html_safe
    else
      ("    " + title + "Unknown\n      </div>").html_safe unless hide
    end
  end
end

