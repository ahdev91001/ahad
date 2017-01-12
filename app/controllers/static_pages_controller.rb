class StaticPagesController < ApplicationController
  include PropertiesHelper
  
  def home
  end

  def help
  end
  
  def testform
  end
  
  def search
    if (params[:id] =~ /^\d+$/)
      redirect_to "/properties/" + params[:id]
    else
      addr_normalized = normalize_address(params[:id])
      
      logger.debug "Hand-typed address (not selected from dropdown list): (" +
        params[:id] + ")"
      logger.debug "  Address text normalized to: (#{addr_normalized})"
      
      @property = Property.find_by address1: addr_normalized

      if @property != nil
        redirect_to "/properties/" + @property.id.to_s
      else
        @address = params[:id] + 
          (params[:id] != addr_normalized ? " (" + addr_normalized + ")" : "")
        render "properties/search_not_found"        
      end
    end
  end
  
end
