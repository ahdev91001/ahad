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
  ###########################################################################
  # #initialize

  # Create PDF version of advanced search criteria and results.
  #
  # @param @params - hash or search criteria
  #
  # @properties - array of found properties
  #
  # @return Nothing
  #
  ###########################################################################
  def initialize(params, properties)

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
  
      text "We do not have a picture of this house yet.", :align => :center

    end

  end # initialize(property)

end # PropertyPdf < Prawn::Document

