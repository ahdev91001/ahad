require 'google_maps_service'

class PropertiesController < ApplicationController
  respond_to :html, :json

  include ::Views::AdvSearchHelper

  skip_before_action :verify_authenticity_token

  # Used by select2 AJAX call to populate its drop-down list.  Upon
  # typing each character, the string currently typed gets sent
  # here for a /.*stuff.*/ match against all the addresses in the database.
  # Note, the "index2" routine below is the routine used to generate
  # an actual page of properties on the screen.
  #
  # @param params[:term] [String] the partial or complete address
  #   that you are matching against or looking for.
  #
  # @return @properties [JSON] an array of hashes with keys :id & :address1
  def index
    @properties = Property.select(:id, :address1).where(
      "address1 LIKE ?", "%#{params[:term]}%")
    if @properties.length == 0
      @properties = [] # [{:id => 0, 
                       #   :address1 => "Not found in our database yet." }]
                       # Was set to above, instead of [], when we didn't allow
                       # users to type in a custom address that was not already
                       # in our database.  (Note, could be an address not in the
                       # DB or could be a typo or 'St.' not 'Street', etc.)
    end
    
    respond_with(@properties)
    # Currently does a 500.html in production on the
    # /properties route because no index.html.erb file. Q: Do we want
    # it to do anything over and above that?  (Q logged in Evernote
    # "404.html for non-existent routes: Design a clever 404 page :)"
    # 1/21/17 DDC)
  end
  
  def show
    source = Property.find(params[:id])
    
    @property = PropertyDecorator.new(source)
    @property = PropArchitectDecorator.new(@property)
    @property = PropBuilderDecorator.new(@property)
    
    gmaps = GoogleMapsService::Client.new(key: 'AIzaSyBgnPpkjO__fzAjoyCUMGyoQgegorqv5rY')
    results = gmaps.geocode("#{@property.address1} #{@property.address2}")
    if results[0] == nil
      @lat = 0 # 34.200503
      @lng = 0 # 118.128852
    else
      @lat = results[0][:geometry][:location][:lat]
      @lng = results[0][:geometry][:location][:lng]
    end
    
    respond_to do |format|
      format.html
      format.pdf do
        pdf = PropertyPdf.new(@property)
  
        send_data pdf.render, 
          filename: "#{@property.address1}".gsub(" ","-") + ".pdf",
          type: 'application/pdf',
          disposition: 'inline'        
      end
    end
  end

  def edit
    @property = Property.find(params[:id])
    if @property.apn == nil
      @property.build_apn
    end
  end
  
  def update
    @property = Property.find(params[:id])
    if @property.update_attributes(property_params)
      flash[:success] = "Property Updated"
      redirect_to @property
    else
      render 'edit'
    end
  end
  
  # index2 actually creates a full page of properties listed.  This
  # differs from "index", which returns a JSON hash and is designed
  # to be used with AJAX and select2.
  def index2
    if params[:filter] != nil && params[:filter].length > 0 then
      @properties = Property.where("address1 LIKE ?", "%#{params[:filter]}%").paginate(page: params[:page], per_page: 30)
    else  
      @properties = Property.paginate(page: params[:page], per_page: 30)
    end
  end
  
  def new
    @property = Property.new
    @property.build_apn
  end
  
  def create
    @property = Property.new(property_params)    # Not the final implementation!
    if @property.save
      flash[:success] = "Property has been created!  Woo hoo!"
      flash.keep # not even sure why this is needed, but it was
      # second answer at: https://stackoverflow.com/questions/7510418/
      #                     rails-redirect-to-with-error-but-flasherror-empty
      redirect_to property_url(@property) 
    else
      render 'new'
    end
  end

  def destroy
    Property.find(params[:id]).destroy
    flash[:success] = "Property deleted"
    redirect_to properties_all_path
  end

  def adv_search
    sql_just_where = get_adv_search_where_sql(params)

    @properties = Property.joins(:prop_builders, :prop_architects, :apn)
            .select("property.*, prop_architect.name as arch_name, " +
                    "prop_architect.confirmed as arch_confirmed, " +
                    "prop_builder.name as build_name, " +
                    "prop_builder.confirmed as build_confirmed")
            .where(sql_just_where) # + " AND (first_architect='Y' AND first_builder='Y')")

    respond_to do |format|
      format.html
      format.pdf do

        pdf = AdvSearchPdf.new(params, @properties)
        send_data pdf.render, 
          filename: "Search-" + Time.now.strftime("%F_%T").gsub(":","-") + ".pdf",
          type: 'application/pdf',
          disposition: 'inline'        
      end
    end
  end

  # Private #################################################################
  
  private

    def property_params
      params.require(:property).permit(
        :address1, :address2, :addressnote, :ahdesignation,
        :architect, :architectconfirmed, :builder, :builderconfirmed,
        :chrs, :currentlotsize, :historicname, :legaldescription,
        :movedontoproperty, :notes_shpo_and_sources, :originalcost,
        :originallotsize, :originalowner, :originalowneroccupation,
        :originalownerspouse, :orig_note_shpo_sources, :placeofbusiness,
        :quadrant, :stories, :streetdirection, :streetname,
        :streetnumberbegin, :streetnumberend, :style, :type,
        :yearbuilt, :yearbuiltassessor, :yearbuiltassessorflag,
        :yearbuiltflag, :yearbuiltother, :yearbuiltotherflag,
        prop_architects_attributes: [:id, :name, :first_architect, :confirmed, :year, :yearflag, :_destroy],
        prop_builders_attributes: [:id, :name, :first_builder, :confirmed, :year, :yearflag, :_destroy],
        prop_chrs_attributes: [:id, :chrs_code, :_destroy],
        building_permits_attributes: [:id, :permit, :year, :_destroy],
        alterations_attributes: [:id, :cost, :description, :year, :_destroy],
        prop_owners_attributes: [:id, :name, :years, :yearflag, :original_owner, :comment, :_destroy],
        prop_resources_attributes: [:id, :filename, :resource_type, :file_format, :description, :date, :credit, :primary_image, :_destroy],
        former_addresses_attributes: [:id, :address1, :address2, :years, :yearflag, :_destroy],
        apn_attributes: [:id, :parcel, :_destroy])
    end
    
end
