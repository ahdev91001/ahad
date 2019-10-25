class PropArchitectDecorator < Draper::Decorator
  include PropertiesHelper
  
  delegate_all

  def architect_qualified
    add_addnl_confirmation_info object.name, object.confirmed,
      "Y", "(confirmed)", "(attributed to)"
  end

end 