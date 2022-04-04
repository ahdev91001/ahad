# TODO: Add comment header
class PropertyDecorator < Draper::Decorator
  include PropertiesHelper
  
  delegate_all

  def yearbuilt_qualified
    add_addnl_confirmation_info object.yearbuilt, object.yearbuiltflag,
      "A", "(actual)", "(estimated)"
  end 

end # class PropertyDecorator < Draper::Decorator