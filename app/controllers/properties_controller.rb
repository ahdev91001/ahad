class PropertiesController < ApplicationController

  def show
    @property = Property.find(params[:id])
    @photo = Photo.find_by(propid: params[:id])
    @apn = APN.find_by(propid: params[:id])
  end

end
