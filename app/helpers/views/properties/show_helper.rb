#############################################################################
# Views::Properties::ShowHelper
#
# Routines specific to the Properties#show view, mainly to remove code
# and complexity from the template.  
#
# Since 1/14/2017 Derek Carlson
#############################################################################
module Views::Properties::ShowHelper

  # TODO: Add header comments
  def ps_markup(name, value, hide=false, hide_nof=false)
    title = "<div class='hanging-indent'> " +
       "<span class='ps-details-titles'> #{name}: </span>"
  
    if (value != nil && value != "" && value != "$")
      ("    " + title + value + "\n      </div>").html_safe
    elsif hide_nof == false
      ("    " + title +
       "Not on File\n      </div>").html_safe unless hide
    else
      ("    " + title + "\n</div>").html_safe unless hide
    end
  end # ps_markup

end #module Views::Properties::ShowHelper