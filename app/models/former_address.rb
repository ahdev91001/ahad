class FormerAddress < ActiveRecord::Base
  belongs_to  :property, foreign_key: :propid 

  self.table_name = "formeraddress"
  
end
