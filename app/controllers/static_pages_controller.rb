class StaticPagesController < ApplicationController
  def home
  end

  def help
  end
  
  def testform
  end
  
  def search
    # If an ID (if selected one of the options from
    # the select2 dropdown), show it
    if (params[:id] =~ /^\d+$/)
      redirect_to "/properties/" + params[:id]
    # Otherwise it's a custom hand-typed address, so
    # clean it up and search for it...
    #
    # - Collapse all \s\s+ down to \s
    # - Upcase everything
    # - Remove all periods after letters (\w)\. => $1
    # - Change Street to ST, Avenue to AVE, etc.
    # - Look for exact match.  
    #    - If found, show it.
    #    - If not, show all that match first word (usu. digits)
    #    -    and show all (or some) that match second word (usu. street)
    else
      @property = Property.find_by address1: params[:id]
      if @property != nil
        redirect_to "/properties/" + @property.id
      else
        @address = params[:id]
        render "properties/search_not_found"        
      end
    end
  end
  
end
