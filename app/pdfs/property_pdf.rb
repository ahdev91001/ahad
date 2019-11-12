#############################################################################
# property_pdf.rb
#
# Renders out the property page into a PDF document using Prawn.  
#
# Since 10/20/2018 Derek Carlson
#############################################################################
require "open-uri"
require "uri"
include ActionView::Helpers::NumberHelper

class PropertyPdf < Prawn::Document
  ###########################################################################
  # #initialize

  # Create PDF version of Properties page.
  #
  # @param @property
  #
  # @return Nothing
  #
  ###########################################################################
  def initialize(property)

    @property = property

    @tmp_cursor = 0
    @starting_new_page = false
    
    info = {
     :Title => @property.address1,
     :Author => "Altadena Heritage",
     :Subject => @property.address1,
     :Creator => "Altadena Heritage Architectural Database",
     :Producer => "Prawn",
     :CreationDate => Time.now
    }

    super(top_margin: 20, :info => info)

    repeat :all do
      # header
      bounding_box [bounds.left, bounds.top], :width  => bounds.width do
          font "Helvetica"
          image Dir.getwd + "/app/assets/images/ahad-header-logo-from-website-alpha-2.png", 
            :position => :center, :width => 350
        
          move_down 10
          text "\xC2\xA9 #{Time.current.year} <link href='http://altadenaheritage.org/'><color rgb='5555FF'>Altadena Heritage</color></link>",
            :align => :center, :size => 10,  :inline_format => true
          stroke_horizontal_rule
          move_down 10
          text "<link href='ahad.altadenaheritagepdb.org/properties/#{@property.id}'>#{@property.address1}</link>", 
            :align => :center, :size => 25, :color => '770000', :inline_format => true
          stroke_color "770000"
      end

      # footer
      bounding_box [bounds.left, bounds.bottom + 25], :width  => bounds.width do
          font "Helvetica"
          stroke_color "770000"
          stroke_horizontal_rule
          move_down 5
      end
    end

  bounding_box([bounds.left, bounds.top - 95], :width => bounds.width) do  

    if !@property.primary_image.nil? && @property.primary_image.filename
      image open("http://altadenaheritagepdb.org/photo/" + URI.encode(@property.primary_image.filename)),
        :position => :center, :height => 200
      move_down 4
      text  (@property.primary_image.description.nil? ? "" : @property.primary_image.description + " ") +
            (@property.primary_image.date.nil? ? "" : "(" + @property.primary_image.date + ") ") +
            (@property.primary_image.credit.nil? || @property.primary_image.credit == ""  ? "" : "Credit: " + @property.primary_image.credit), 
            :size => 9, :align => :center,  :inline_format => true
            
    else
      image Dir.getwd + "/app/assets/images/house-stick-figure-med.png", 
      :position => :center, :width => 250
      text "We do not have a picture of this house yet.", :align => :center
      text "<link href='http://altadenaheritage.org/contact-us/'><color rgb='5555FF'>" +
            "Let us know</color></link> if you have one!",  :align => :center,  :inline_format => true
    end

  end

  bounding_box([119, 630], :width => 540-119, :height => 600) do  
    move_down 210
    
    if @property.apn == nil 
      text "<color rgb='777777'>APN:</color> Not on File", :inline_format => true
    else  
      text ps_markup_pdf("APN", (apn = @property.apn) && apn.parcel, false), 
        :inline_format => true
    end

    text "<link href='ahad.altadenaheritagepdb.org/properties/#{@property.id}'><color rgb='777777'>AHAD ID:</color> #{@property.id}</link>", 
            :align => :left, :inline_format => true

    if @property.yearbuilt_qualified != nil
      text ps_markup_pdf("Year Built", @property.yearbuilt_qualified, false), 
        :inline_format => true
    end
    
    if @property.yearbuiltassessor != nil
      text ps_markup_pdf("Year Built (Assessor)", @property.yearbuiltassessor, false), 
        :inline_format => true
    end

    if @property.yearbuiltother != nil
      text ps_markup_pdf("Year Built (Other)", @property.yearbuiltother, false), 
        :inline_format => true
    end

    if @property.legaldescription == nil 
      text "<color rgb='777777'>Legal Description:</color> Not on File", :inline_format => true
    else
      text ps_markup_pdf("Legal Description", @property.legaldescription, false), 
        :inline_format => true
    end

    if @property.quadrant == nil 
      text "<color rgb='777777'>Quadrant:</color> Not on File", :inline_format => true
    else
      text  ps_markup_pdf("Quadrant", @property.quadrant, false), 
        :inline_format => true
    end

    if @property.currentlotsize == nil 
      text "<color rgb='777777'>Current Lot Size:</color> Not on File", :inline_format => true
    else
      text ps_markup_pdf("Current Lot Size", @property.currentlotsize, false), 
        :inline_format => true
    end

    if @property.historicname == nil 
      text "<color rgb='777777'>Historic Name:</color> Not on File", :inline_format => true
    else
      text ps_markup_pdf("Historic Name", @property.historicname, false), 
        :inline_format => true
    end

    if @property.style == nil 
      text "<color rgb='777777'>Style:</color> Not on File", :inline_format => true
    else
      text ps_markup_pdf("Style", @property.style, false), 
        :inline_format => true
    end

    if @property.stories != nil then
      text ps_markup_pdf("Stories", @property.stories, false), 
        :inline_format => true
    end

    if @property.type == nil 
      text "<color rgb='777777'>Type:</color> Not on File", :inline_format => true
    else
      text  ps_markup_pdf("Type", @property.type != nil ? @property.type.capitalize : "", false), 
        :inline_format => true
    end

    if @property.chrs_codes == "" 
      text "<color rgb='777777'>CHRS:</color> Not on File", :inline_format => true
    else  
      text ps_markup_pdf("CHRS", @property.chrs_codes, false), 
        :inline_format => true
    end

    #
    # Architects
    #
    if cursor < 80.0
      start_new_page
    end
    
    if !@property.first_architect.nil?
      a = PropArchitectDecorator.new(@property.first_architect)
      if @property.prop_architects.count > 1
        text ps_markup_pdf("Architects", a.qualified + (a.year != nil ? " (" + a.year + ")" : "")), 
          :inline_format => true
      else
        text ps_markup_pdf("Architect", a.qualified + (a.year != nil ? " (" + a.year + ")" : "")), 
          :inline_format => true
      end
    end

    bounding_box([30, cursor], :width => 390) do  
      if @property.other_architects.count > 0
        @property.other_architects.each do |aa|
            aa = PropArchitectDecorator.new(aa)
            text aa.qualified + (aa.year != nil ? " (" + aa.year + ")" : ""),
              :inline_format => true
        end
      end
    end

    #
    # Builders
    #
  
    if cursor < 80.0
      start_new_page
    end
 
    if !@property.first_builder.nil?
      b = PropBuilderDecorator.new(@property.first_builder)
      if @property.prop_builders.count > 1
        text ps_markup_pdf("Builders", b.qualified + (b.year != nil ? " (" + b.year + ")" : ""), false, true), 
          :inline_format => true
      else
        text ps_markup_pdf("Builder", b.qualified + (b.year != nil ? " (" + b.year + ")" : "")), 
          :inline_format => true
      end
    end

    bounding_box([30, cursor], :width => 390) do  
      if @property.other_builders.count > 0
        @property.other_builders.each do |bb|
            bb= PropBuilderDecorator.new(bb)
            text bb.qualified + (bb.year != nil ? " (" + bb.year + ")" : ""),
              :inline_format => true
        end
      end
    end

    # 
    # Building Permits
    #
    if cursor < 80.0
      start_new_page
    end
    
    if @property.building_permits.count > 0
      text "<color rgb='777777'>Building Permits:</color>", :inline_format => true

      bounding_box([30, cursor], :width => 390) do  
        data = [["Permit", "Year"]]
        @property.building_permits.each do |a|
          data += [[a.permit,
                    a.year != nil ? a.year : "N/A"]]
        end
        table(data, :row_colors => ["C0C0C0", "FFFFFF"])
        move_down 7
      end
    else
      text "<color rgb='777777'>Building Permits:</color> None on File", :inline_format => true
    end
    
    # 
    # Alterations
    #
    if cursor < 80.0
      start_new_page
    end
    
    if @property.alterations.count > 0
      text "<color rgb='777777'>Alterations:</color>", :inline_format => true

      bounding_box([30, cursor], :width => 390) do  
        data = [["Cost", "Description", "Year"]]
        @property.alterations.each do |a|
          data += [[number_to_currency(a.cost, :precision => 0),
                    a.description != nil ? a.description : "N/A",
                    a.year != nil ? a.year : "N/A"]]
        end
        table(data, :row_colors => ["C0C0C0", "FFFFFF"])
        move_down 7
      end
    else
      text "<color rgb='777777'>Alterations:</color> None on File", :inline_format => true
    end
  
  
    if @property.original_owner == nil 
      text "<color rgb='777777'>Original Owner:</color> Not on File", :inline_format => true
    else
      text ps_markup_pdf("Original Owner", @property.original_owner.name + (@property.original_owner.comment.nil? ? "" : " (" + @property.original_owner.comment + ")"), false), 
        :inline_format => true
    end

    if @property.originalowneroccupation == nil 
      text "<color rgb='777777'>Original Owner Occupation:</color> Not on File", :inline_format => true
    else
      text  ps_markup_pdf("Original Owner Occupation", @property.originalowneroccupation, false), 
        :inline_format => true
    end

    if @property.placeofbusiness == nil 
      text "<color rgb='777777'>Place of Business:</color> Not on File", :inline_format => true
    else
      text  ps_markup_pdf("Place of Business", @property.placeofbusiness, false), 
        :inline_format => true
    end

    # 
    #  Other Owners
    #
    if cursor < 80.0
      start_new_page
    end
    
    if @property.other_owners.count > 0
      text "<color rgb='777777'>Other Owners:</color>", :inline_format => true

      bounding_box([30, cursor], :width => 390) do  
        data = [["Address", "Years", "Comment"]]
        @property.other_owners.each do |a|
          data += [[a.name,
                    a.years != nil ? a.years : "N/A",
                    a.comment != nil ? a.comment : "N/A"]]
        end
        table(data, :row_colors => ["C0C0C0", "FFFFFF"])
        move_down 7
      end
    else
      text "<color rgb='777777'>Other Owners:</color> None on File", :inline_format => true
    end
    
    if @property.originalcost == nil 
      text "<color rgb='777777'>Original Cost:</color> Not on File", :inline_format => true
    else
      text  ps_markup_pdf("Original Cost", 
        number_to_currency(@property.originalcost, :precision => 0), false), 
        :inline_format => true
    end

    if @property.originallotsize == nil 
      text "<color rgb='777777'>Original Lot Size:</color> Not on File", :inline_format => true
    else
      text  ps_markup_pdf("Original Lot Size", @property.originallotsize, false), 
        :inline_format => true
    end

    if @property.movedontoproperty == nil 
      text "<color rgb='777777'>Moved on to Property:</color> Not on File", :inline_format => true
    else
      text  ps_markup_pdf("Moved on to Property", @property.movedontoproperty, false), 
        :inline_format => true
    end

    # 
    # Former Addresses
    #
    if cursor < 40.0
      start_new_page
    end
    
    if @property.former_addresses.count > 0
      text "<color rgb='777777'>Former Addresses:</color>", :inline_format => true

      bounding_box([30, cursor], :width => 390) do  
        data = [["Address", "Years"]]
        @property.former_addresses.each do |a|
          data += [[a.address1 + "  " + a.address2,
                    a.years != nil ? a.years : "N/A"]]
        end
        table(data, :row_colors => ["C0C0C0", "FFFFFF"])
        move_down 7
      end
    else
      text "<color rgb='777777'>Former Addresses:</color> None on File", :inline_format => true
    end

    if @property.addressnote == nil 
      text "<color rgb='777777'>Address Notes:</color> Not on File", :inline_format => true
    else
      text  ps_markup_pdf("Address Notes", @property.addressnote, false), 
        :inline_format => true
    end

    move_down 10
    
    if @property.notes_shpo_and_sources != nil
      text @property.notes_shpo_and_sources.
        gsub("## Note","<color rgb='777777'>Note:</color>").
        gsub("## Sources","<color rgb='777777'>Sources:</color>"), 
        :inline_format => true
    end 

    move_down 20

    @tmp_cursor = cursor

    # 
    # CHRS Codes Key
    #
    if cursor < 60.0
      @starting_new_page = true
      start_new_page
    end
  end

   bounding_box([75, 630], :width => 540-150, :height => 600) do
      
      if !@starting_new_page
        move_down bounds.top -  @tmp_cursor
      end

      text "<color rgb='777777'>California Historical Resource Status (CHRS) Codes Key</color>", :inline_format => true, :size => 9

      data = [["Code", "Description"]]
      Chrs.all.each do |c|
        data += [[c.code, c.description]]
      end
      table(data, :cell_style => { :size => 9, :padding => 1 }) do
        column(0).width = 48
        columns(0).valign = :top
        rows(0).valign = :center
        cells.borders = []
      end
      move_down 27

      text "Do you find this property data informative and useful? Consider <link href='http://altadenaheritage.org/donate/'><color rgb='5555FF'>supporting Altadena Heritage.</color></link>",
        :align => :left, :size => 10,  :inline_format => true

    end

  # Page numbering (duh)
  
  string = 'Page <page>/<total>'
  options = {
    at: [bounds.right - 400, 0],
    width: 150,
    align: :right,
    start_count_at: 1,
    color: '770000'
  }
  number_pages string, options

  end # initialize(property)

  ###########################################################################
  # #ps_markup_pdf

  # Create PDF version of Properties page.
  #
  # @param name [String] The name of the 'property'
  #
  # @param value [String] The value of the 'property'
  #
  # @param hide [Boolean] Don't return any output at all if value is nil
  #
  # @param hide_nof [Boolean] If value is nil, show 'property' anyway, but
  #  don't show 'Not on File'.
  #
  # @return The formatted string, with or without "Not on File", or a
  #  blank string.
  #
  ###########################################################################
  def ps_markup_pdf(name, value, hide=false, hide_nof=false)
  
    if (value != nil) && (value != "") && (value != "$")
      "<color rgb='777777'>#{name}:</color> #{value}"
    elsif hide_nof == false
      "<color rgb='777777'>#{name}:</color> Not on File" unless hide
    else
      "<color rgb='777777'>#{name}:</color>" unless hide
    end
  
  end # ps_markup_pdf
  
end # PropertyPdf < Prawn::Document

