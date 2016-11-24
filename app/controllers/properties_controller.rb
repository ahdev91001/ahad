class PropertiesController < ApplicationController
  respond_to :html, :json

  def index
    @properties = Property.select(:id, :address1).where("address1 LIKE '%#{params[:term]}%'")
    if @properties.length == 0
      @properties = [{:id => 0, :address1 => "Not found in our database yet." }]
    end
    respond_with(@properties)
  end
  
  def show
    @property = Property.find(params[:id])
    @photo = Photo.find_by(propid: params[:id])
    @apn = APN.find_by(propid: params[:id])
  end

end
