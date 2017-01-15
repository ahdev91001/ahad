class PropertiesController < ApplicationController
  respond_to :html, :json

  def index
    @properties = Property.select(:id, :address1).where("address1 LIKE '%#{params[:term]}%'")
    if @properties.length == 0
      @properties = [] # [{:id => 0, 
                       #   :address1 => "Not found in our database yet." }]
                       # Was set to above, instead of [], when we didn't allow
                       # users to type in a custom address that was not already
                       # in our database.  (Note, could be an address not in the
                       # DB or could be a typo or 'St.' not 'Street', etc.)
    end
    respond_with(@properties)
  end
  
  def show
    source = Property.find(params[:id])
    @property = PropertyDecorator.new(source)
    @photo = Photo.find_by(propid: params[:id])
    @apn = Apn.find_by(propid: params[:id])
  end

end
