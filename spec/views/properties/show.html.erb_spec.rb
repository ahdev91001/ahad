require "rails_helper"

describe "properties/show.html.erb" do
  
  it "displays a field's name and value" do
    assign(
      :property,
      FactoryGirl.build_stubbed(:property, stories: 2)
    )
    
    render
    expect(rendered).to match(/Stories.*2/m)
  end
  
  
  it "displays the field name then 'Unknown' if a field is empty" do
    assign(
      :property,
      FactoryGirl.build_stubbed(:property, stories: nil)
    )
    
    render
    expect(rendered).to match(/Stories.*Unknown/m)
  end

  it "does not display anything when the field is set to " +
     "'don't show anything when the value is nil'" do
    assign(
      :property,
      FactoryGirl.build_stubbed(:property, originalownerspouse: nil)
    )
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
    #    Original Owner Spouse: Unknown
    #
    # When in fact the entire line should be removed from the output,
    # no title, nuthin'.
    render
    expect(rendered).not_to  match(/Original Owner Spouse/m)
  end

  it "displays (confirmed) when a confirmable value has a " +
    "'Y' in its corresponding confirm field" do
    assign(
      :property,
      FactoryGirl.build_stubbed(:property, builder: "Jones",
                                           builderconfirmed: "Y")
    )
    
    render
    expect(rendered).to match(/Builder.*Jones \(confirmed\)/m)
  end

  it "displays (unconfirmed) when a confirmable value has an " +
    "'n' in its corresponding confirm field" do
    assign(
      :property,
      FactoryGirl.build_stubbed(:property, builder: "Jones",
                                           builderconfirmed: "n")
    ) # note, lowercase "n" intentional to ensure upcasing
    
    render
    expect(rendered).to match(/Builder.*Jones \(unconfirmed\)/m)
  end

  it "displays (unconfirmed) when a confirmable value's confirm " +
    "field is the empty string (not nil)" do
    assign(
      :property,
      FactoryGirl.build_stubbed(:property, builder: "Jones",
                                           builderconfirmed: "")
    ) # note, lowercase "n" intentional to ensure upcasing
    
    render
    expect(rendered).to match(/Builder.*Jones \(unconfirmed\)/m)
  end

  it "displays (unconfirmed) when a confirmable value's confirm " +
    "field is nil" do
    assign(
      :property,
      FactoryGirl.build_stubbed(:property, builder: "Jones",
                                           builderconfirmed: nil)
    ) # note, lowercase "n" intentional to ensure upcasing
    
    render
    expect(rendered).to match(/Builder.*Jones \(unconfirmed\)/m)
  end

  it "displays (actual) when a date's confirm field is set to 'A'" do
    assign(
      :property,
      FactoryGirl.build_stubbed(:property, yearbuilt: 1911,
                                           yearbuiltflag: "A")
    )
    
    render
    expect(rendered).to match(/Year Built.*1911 \(actual\)/m)
  end

  it "displays (estimated) when a date's confirm field is set to 'E'" do
    assign(
      :property,
      FactoryGirl.build_stubbed(:property, yearbuilt: 1911,
                                           yearbuiltflag: "E")
    )
    
    render
    expect(rendered).to match(/Year Built.*1911 \(estimated\)/m)
  end
  
  it "displays (estimated) when a date's confirm field is nil" do
    assign(
      :property,
      FactoryGirl.build_stubbed(:property, yearbuilt: 1911,
                                           yearbuiltflag: nil)
    )
    
    render
    expect(rendered).to match(/Year Built.*1911 \(estimated\)/m)
  end
  
end