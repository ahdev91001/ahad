class PropBuilderDecorator < Draper::Decorator
  include PropertiesHelper
  
  delegate_all

  def qualified
    builder_qualified(object.name, object.confirmed)
  end

end 