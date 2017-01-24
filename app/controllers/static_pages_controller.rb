class StaticPagesController < ApplicationController
  include PropertiesHelper
  
  def home
  end

  def help
  end
  
  def testform
  end
  
  # Search for a property based on ID or an address.  Addresses of various
  # forms (e.g. St, St., Street, etc.) will be normalized, if possible,
  # into the format for addresses in the database (see the normalize_address
  # routine for details).
  #
  # @param params[:id] [Integer or String] either the id of a property in
  #   the database or an actual street address (without city, state, zip)
  #
  # Will either redirect to the property#show page for a found property,
  # or will be redirected to a "Property Not Found" page.
  def search
    if (params[:id] =~ /^\d+$/)
      redirect_to "/properties/" + params[:id]
    else
      addr_normalized = normalize_address(params[:id])
      
      logger.debug "Hand-typed address (not selected from dropdown list): (" +
        params[:id] + ")"
      logger.debug "  Address text normalized to: (#{addr_normalized})"

      # Use LIKE to work with sqlite as well as mysql2       
      @property = Property.where("address1 LIKE ?", "%#{addr_normalized}%")[0]
      
      # Below worked for mysql2 which does case-insensitive matching,
      # but sqlite only does case-insensitive matching in LIKE statements.
      # Got this from: http://stackoverflow.com/questions/2220423/
      #   case-insensitive-search-in-rails-model
      # The reply that starts with: "Quoting from the SQLite documentation:"
      #@property = Property.find_by address1: addr_normalized

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
