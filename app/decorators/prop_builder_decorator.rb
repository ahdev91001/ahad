class PropBuilderDecorator < Draper::Decorator
  include PropertiesHelper
  
  delegate_all

  def builder_qualified
    add_addnl_confirmation_info object.name, object.confirmed,
      "Y", "(confirmed)", "(unconfirmed)"
  end

end 