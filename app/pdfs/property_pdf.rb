require "open-uri"

class PropertyPdf < Prawn::Document
  def initialize(property)

    @property = property
    
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
          text "\##{@property.address1}", :align => :center, :size => 25, :color => '770000'
          stroke_color "770000"
          stroke_horizontal_rule
      end

      # footer
      bounding_box [bounds.left, bounds.bottom + 25], :width  => bounds.width do
          font "Helvetica"
          stroke_color "770000"
          stroke_horizontal_rule
      end
    end
  
  move_down 10

#  text Dir.getwd + "/app/assets/images/ahad-header-logo-from-website-alpha-2.png"
  image Dir.getwd + "/app/assets/images/ahad-header-logo-from-website-alpha-2.png", :position => :center, :width => 350

  move_down 10
  text "Report from Altadena Heritage Architectural Database courtesy of <link href='http://altadenaheritage.org/'><color rgb='5555FF'>AltadenaHeritage.org</color></link>", :align => :center, :size => 10,  :inline_format => true

  move_down 20

  image open("http://altadenaheritagepdb.org/photo/11136_photo_01.jpg"), :position => :center, :width => 300


  move_down 10
  text "<link href='https://pacific-garden-24850.herokuapp.com/properties/11136'><color rgb='5555FF'><u>#{@property.address1}</u></color></link>",
      :inline_format => true, :align => :center


  10.times do
    start_new_page
    text 'Here comes yet another page.'
  end


  string = 'Page <page>/<total>'
  # Green page numbers 1 to 7
  options = {
    at: [bounds.right - 393, 0],
    width: 150,
    align: :right,
    page_filter: (1..7),
    start_count_at: 1,
    color: '770000'
  }
  number_pages string, options

  # Gray page numbers from 8 on up
  options[:page_filter] = ->(pg) { pg > 7 }
  options[:start_count_at] = 8
  options[:color] = '333333'
  number_pages string, options

  start_new_page
  text "See. This page isn't numbered and doesn't count towards the total."    
  
  end
end