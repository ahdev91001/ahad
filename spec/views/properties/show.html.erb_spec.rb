require "rails_helper"
#############################################################################
# View Spec for: properties/show.html.erb
#
# TODO: As listed multiple places below, decouple from database and create
# mock property and apn and photo objects for the view to use, so that
# when the view does @property.apn or @property.photos.first, those calls
# use the mock objects and do not hit the database.  1/15/17 DDC.
#
# Since 1/14/2017 Derek Carlson
#############################################################################

describe "properties/show.html.erb" do
  include Views::Properties::ShowHelper  
  
  it "displays a field's name and value" do
    assign(:property,
      FactoryGirl.build_stubbed(:property, stories: 2))
    
    render
    expect(rendered).to match(/Stories.*2/m)
  end
  
  
  it "displays the field name then 'Not on File' if a field is empty" do
    assign(:property,
      FactoryGirl.build_stubbed(:property, stories: nil))
    
    render
    expect(rendered).to match(/Stories.*Not on File/m)
  end

  it "does not display anything when the field is set to " +
     "'don't show anything when the value is nil'" do
    assign(:property,
      FactoryGirl.build_stubbed(:property, originalownerspouse: nil))
    # TODO: Need to implement a "Display Settings" system so we can
    # programmatically tell the system to hide certain fields when nil.
    # Since that's not yet implemented, I know the view contains the
    # Original Owner Spouse field which should be hidden when nil, so
    # that's hardcoded and in-place for this test.  Once the "Display
    # Settings" system is in place, the view will be modified to use
    # that system to determine whether or not to display a nil field,
    # and then we can control that from here.
    #
    # Right now, if not hidden, the essence of the erroneous output 
    # for a nil Original Owner Spouse field looks like:
    #
    #    Original Owner Spouse: Not on File
    #
    # When in fact the entire line should be removed from the output,
    # no title, nuthin'.
    render
    expect(rendered).not_to  match(/Original Owner Spouse/m)
  end

  it "displays (confirmed) when a confirmable value has a " +
    "'Y' in its corresponding confirm field" do
    assign(:property,
      FactoryGirl.build_stubbed(:property, builder: "Jones",
                                           builderconfirmed: "Y"))
    
    render
    expect(rendered).to match(/Builder.*Jones \(confirmed\)/m)
  end

  it "displays (unconfirmed) when a confirmable value has an " +
    "'n' in its corresponding confirm field" do
    assign(:property,
      FactoryGirl.build_stubbed(:property, builder: "Jones",
                                           builderconfirmed: "n"))
      # note, lowercase "n" intentional to ensure upcasing
    
    render
    expect(rendered).to match(/Builder.*Jones \(unconfirmed\)/m)
  end

  it "displays (unconfirmed) when a confirmable value's confirm " +
    "field is the empty string (not nil)" do
    assign(:property,
      FactoryGirl.build_stubbed(:property, builder: "Jones",
                                           builderconfirmed: ""))
    
    render
    expect(rendered).to match(/Builder.*Jones \(unconfirmed\)/m)
  end

  it "displays (unconfirmed) when a confirmable value's confirm " +
    "field is nil" do
    assign(:property,
      FactoryGirl.build_stubbed(:property, builder: "Jones",
                                           builderconfirmed: nil)) 

    render
    expect(rendered).to match(/Builder.*Jones \(unconfirmed\)/m)
  end

  it "displays (actual) when a date's confirm field is set to 'A'" do
    assign(:property,
      FactoryGirl.build_stubbed(:property, yearbuilt: 1911,
                                           yearbuiltflag: "A"))
    
    render
    expect(rendered).to match(/Year Built.*1911 \(actual\)/m)
  end

  it "displays (estimated) when a date's confirm field is set to 'E'" do
    assign(:property,
      FactoryGirl.build_stubbed(:property, yearbuilt: 1911,
                                           yearbuiltflag: "E"))
    
    render
    expect(rendered).to match(/Year Built.*1911 \(estimated\)/m)
  end
  
  it "displays (estimated) when a date's confirm field is nil" do
    assign(:property,
      FactoryGirl.build_stubbed(:property, yearbuilt: 1911,
                                           yearbuiltflag: nil))
    
    render
    expect(rendered).to match(/Year Built.*1911 \(estimated\)/m)
  end

  # Also see Evernote 'rails(ahad)' notebook note named:
  # "FactoryGirl and RSpec: has_one and has_many associations 
  #   setup for Property#show view spec"
  it "displays the APN when it's available" do
    # Use below if want to run through the DB instead of using stubs
    #apn = FactoryGirl.create(:apn, parcel: "5844-015-004") # [1]
    #assign(:property, Property.find(apn.propid))           # [1]

    # 5844-015-004 is for 1090 Rubio St.
    apn = double('apn', :parcel => "5844-015-004" )     # [2]
    @property = FactoryGirl.build_stubbed(:property)    # [2]
    allow(@property).to receive(:apn).and_return(apn)   # [2]
    assign(:property, @property)                        # [2]

    render
    expect(rendered).to match(/APN.*5844-015-004/m)
  end
  
  # Note: below, we can't create an apn object with parcel
  # nil because MySQL has a Not Null constraint on parcel.
  # We can't just build it in memory, because the view
  # calls @property.apn, which does a database lookup
  # for the apn (via the association), which would not exist
  # if we just built it in memory. So for this one it's necessary 
  # to create a mock property object for the test.
  #
  # Just because we can't insert a nil value into parcel into
  # the database doesn't mean that it's impossible, due to data 
  # corruption or due to the constraint being lifted in the future,
  # that a nil parcel exists.
  it "displays 'APN: Not on File' when the parcel field is nil" do

    apn = double('apn', :parcel => nil )
    @property = FactoryGirl.build_stubbed(:property)
    allow(@property).to receive(:apn).and_return(apn)
    assign(:property, @property)

    render
    expect(rendered).to match(/APN.*Not on File/m)
  end

  # NOTE: Change this when View Settings are implemented, to
  # ensure that APN is set to "Show" so it passes the spec
  it "displays 'APN: Not on File' when the parcel field is the empty string" do
    # Below runs through the DB instead of using stubs
    #apn = FactoryGirl.create(:apn, parcel: "")
    #assign(:property, Property.find(apn.propid))

    apn = double('apn', :parcel => "" )
    @property = FactoryGirl.build_stubbed(:property)
    allow(@property).to receive(:apn).and_return(apn)
    assign(:property, @property)

    render
    expect(rendered).to match(/APN.*Not on File/m)
  end

  # NOTE: Change this when View Settings are implemented, to
  # ensure that APN is set to "Show" so it passes the spec
  it "displays 'APN: Not on File' when there is no associated " +
      "APN record" do
    assign(:property, FactoryGirl.build_stubbed(:property))

    render
    expect(rendered).to match(/APN.*Not on File/m)
  end

  it "it displays a photo", :wip => true  do
    # Use below to run through the database instead of stubs    
    #photo = FactoryGirl.create(:photo, filename: "16494_photo_01.jpg")
    #assign(:property, Property.find(photo.propid))

    # 16494_photo_01.jpg is for 1090 Rubio St.
    photos = double('photos', 
      :first => double('first', :filename => "16494_photo_01.jpg"))
    @property = FactoryGirl.build_stubbed(:property)
    allow(@property).to receive(:photos).and_return(photos)
    
    assign(:property, @property)

    render
    expect(rendered).to match(/16494_photo_01.jpg/m)
  end

  it "with no photo, it displays a placeholder photo"  do
    assign(:property, FactoryGirl.build_stubbed(:property))

    render
    expect(rendered).to have_css("#ps-photo-main-no-photo")
  end
  
end