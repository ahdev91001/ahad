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
    # Currently does a 500.html in production on the
    # /properties route because no index.html.erb file. Q: Do we want
    # it to do anything over and above that?  (Q logged in Evernote
    # "404.html for non-existent routes: Design a clever 404 page :)"
    # 1/21/17 DDC)
  end
  
  # Does nothing special yet. :)
  def show
    source = Property.find(params[:id])
    @property = PropertyDecorator.new(source)

    respond_to do |format|
      format.html
      format.pdf do
        pdf = PropertyPdf.new(@property)
  
        fname = "#{@property.address1}".gsub(" ","-") + ".pdf"

        send_data pdf.render, 
          filename: "#{@property.address1}".gsub(" ","-") + ".pdf",
          type: 'application/pdf',
          disposition: 'inline'        
      end
    end
  end

  def edit
    @property = Property.find(params[:id])
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
  
  def index2
    if params[:filter] != nil && params[:filter].length > 0 then
      # Below is a serious security risk
      # (https://guides.rubyonrails.org/active_record_querying.html#pure-string-conditions)
      query = "address1 LIKE \"%#{params[:filter]}%\""
      # But below doesn't work      
      @properties = Property.where("address1 LIKE \"%:the_filter%\"", {the_filter: params[:filter]}).paginate(page: params[:page], per_page: 30)
      # Thus, for now...
      @properties = Property.where(query).paginate(page: params[:page], per_page: 30)
    else  
      @properties = Property.paginate(page: params[:page], per_page: 30)
    end
  end
  
  def new
    @property = Property.new
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
    redirect_to users_url
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
        :yearbuiltflag, :yearbuiltother, :yearbuiltotherflag)
    end
    
end
