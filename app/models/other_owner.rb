class OtherOwner < ActiveRecord::Base
  belongs_to  :property, foreign_key: :propid 

  self.table_name = "otherowner"
  
end
