class Property < ActiveRecord::Base
  has_many :photos, foreign_key: "propid"
  has_one :apn, foreign_key: "propid"
  
  self.inheritance_column = nil # required because property table has a type
  # column, and that is a reserved name used for Single Table Inheritance
  # per convention.  If need STI, change nil to :sti_type and probably
  # add a migration to add that column to the DB.

  self.table_name = "property"

end
