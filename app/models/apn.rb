class Apn < ActiveRecord::Base
  belongs_to  :property
  self.table_name = "apn"
  
end