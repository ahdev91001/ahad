#############################################################################
# Views::Properties::ShowHelper
#
# Routines specific to the Properties#show view, mainly to remove code
# and complexity from the template.  Note: if a routine is going to be used
# across multiple views, don't put it here.
#
# Since 1/14/2017 Derek Carlson
#############################################################################
module Views::Properties::ShowHelper

  ###########################################################################
  # #ps_markup_field_or_hide

  # Generate markup for any field containing field title and value.
  #
  # If value is nil, then markup will either be nil or will
  # contain '[Field Title]: Unknown', depending on what the view
  # setting is for that field when it's nil.
  #
  # @author Derek Carlson <carlson.derek@gmail.com>
  #
  # @param name [String] the name of the field title formatted
  #   for display on the screen (e.g. Original Owner)
  #
  # @param value [String, nil] the value for the field.  Ok to
  #   be nil.
  #
  # @param hide [Boolean] optional: defaults to false.  If true
  #   then a nil value will cause nil to be returned, resulting
  #   in nothing being shown on the screen.
  #
  # @param ext_field [String]  STOP HERE
  # @return [String, nil]      STOP HERE
  #
  # Note explain why chose optional args instead of options
  # hash.
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

