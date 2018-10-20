class PropertyPdf < Prawn::Document
  def initialize(property)
    super(top_margin: 20)
    @property = property
    text "\##{@property.address1}", :align => :right, :size => 18
  end
end