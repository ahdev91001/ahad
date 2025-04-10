class Alteration < ActiveRecord::Base
  belongs_to  :property, foreign_key: :propid 

  self.table_name = "alteration"
  
end
