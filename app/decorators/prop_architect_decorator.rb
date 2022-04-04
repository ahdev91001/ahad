class PropArchitectDecorator < Draper::Decorator
  include PropertiesHelper
  
  delegate_all

  def qualified
    architect_qualified(object.name, object.confirmed)
  end

end 