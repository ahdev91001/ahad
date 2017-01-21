class PropertiesController < ApplicationController
  respond_to :html, :json

  # Used by select2 AJAX call to populate its drop-down list.  Upon
  # typing each character, the string currently typed gets sent
  # here for a /.*stuff.*/ match against all the addresses in the database.
  #
  # @param params[:term] [String] the partial or complete address
  #   that you are matching against or looking for.
  #
  # @return @properties [JSON] an array of hashes with keys :id & :address1
  def index
    @properties = Property.select(:id, :address1).where(
      "address1 LIKE '%#{params[:term]}%'")
    if @properties.length == 0
      @properties = [] # [{:id => 0, 
                       #   :address1 => "Not found in our database yet." }]
                       # Was set to above, instead of [], when we didn't allow
                       # users to type in a custom address that was not already
                       # in our database.  (Note, could be an address not in the
                       # DB or could be a typo or 'St.' not 'Street', etc.)
    end
    respond_with(@properties)
    # TODO: currently crashes on /properties/ ... no index.html.erb file
  end
  
  # Does nothing special yet. :)
  def show
    source = Property.find(params[:id])
    @property = PropertyDecorator.new(source)
  end

end
