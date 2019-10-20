#############################################################################
# adv_search_pdf.rb
#
# Renders out the advanced search criteria and results into a PDF document
# using Prawn.  
#
# Since 10/7/2019 Derek Carlson
#############################################################################
require "open-uri"
require "uri"
include ActionView::Helpers::NumberHelper

class AdvSearchPdf < Prawn::Document
  
  include Views::AdvSearchHelper
  
  ###########################################################################
  # #initialize

  # Create PDF version of advanced search criteria and results.
  #
  # @param @params - hash of search criteria
  #
  # @properties - array of found properties
  #
  # @return Nothing
  #
  ###########################################################################
  def initialize(params, properties)

    old_y = 0
    
    info = {
     :Title => "Advanced Search",
     :Author => "Altadena Heritage",
     :Subject => "Search Results",
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
          stroke_color "770000"
      end

      # footer
      bounding_box [bounds.left, bounds.bottom + 25], :width  => bounds.width do
          font "Helvetica"
          stroke_color "770000"
          move_down 5
      end
    end

    bounding_box([bounds.left, bounds.top - 80], :width => bounds.width) do  
  
      text "Search Results", :size => 20, :align => :center
      text "# of properties: " + properties.count.to_s, :size => 12, :align => :center
      move_down 5
      text "Search Criteria", :size => 15
      move_down 5
      text "Street: " + params[:filter] if !params[:filter].nil? and params[:filter] != ""
      text "APN: " + params[:apn] if !params[:apn].nil? and params[:apn] != ""
      text "AHAD ID: " + params[:ahadid] if !params[:ahadid].nil? and params[:ahadid] != ""
      
      #params.each do |key, value|
      #  text "The hash key is #{key} and the value is [#{value}]"
      #end

      text pdf_array_criteria_formatter(params[:architects], "Architect")

      if !params[:fuzzy_architects].nil? and params[:fuzzy_architects][0..7] != "Separate" then
        text "Other Architects (" + params[:fuzzy_architects_comparison] + "): " + params[:fuzzy_architects]
      end

      text pdf_array_criteria_formatter(params[:builders], "Builder")

      if !params[:fuzzy_builders].nil? and params[:fuzzy_builders][0..7] != "Separate" then
        text "Other Builders (" + params[:fuzzy_builders_comparison] + "): " + params[:fuzzy_builders]
      end

      if !params[:yearbuilt_from_year].nil? and params[:yearbuilt_from_year] != "" then
        if params[:yearbuilt_comparison] != "Is Between" then
          text "Year Built " + params[:yearbuilt_comparison] + " " + params[:yearbuilt_from_year]
        else
          text "Year Built " + params[:yearbuilt_comparison] + " " + params[:yearbuilt_from_year] +
            " and " + params[:yearbuilt_to_year]
        end
      end
      
      text pdf_array_criteria_formatter(params[:styles], "Style")

      text pdf_array_criteria_formatter(params[:types], "Type")

      old_y = y

    end
    
    move_down 20
    
    bounding_box([bounds.left, bounds.top-65], :width => bounds.width, :height => bounds.height-70) do
      
      #stroke_bounds
      
      data = [["Property", "Architect", "Builder", "Year Built", "Style", "Type"]]
      
      properties.each do |p|
        pd = PropertyDecorator.new(p)
        data += [[pd.address1, pd.architect_qualified, pd.builder_qualified, 
                  pd.yearbuilt_qualified, pd.style, 
                  pd.type.nil? ? " " : pd.type.capitalize]]
      end
      
      self.y = old_y - 10 
      
      table(data, :row_colors => ["C0C0C0", "FFFFFF"], :header => true, :cell_style => { :size => 9, :padding => 1 }) do
        row(0).valign = :top
        row(0).background_color = 'd6ac52'
        row(0).font_style = :bold
  
        column(0).width = 100
        column(1).width = 100
        column(2).width = 100
        column(3).width = 80
        column(4).width = 80
        column(5).width = 80
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

end # AdvSearchPdf < Prawn::Document

