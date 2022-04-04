class PropOwner < ActiveRecord::Base
  belongs_to  :property, foreign_key: :propid 

  self.table_name = "prop_owner"
  
end
