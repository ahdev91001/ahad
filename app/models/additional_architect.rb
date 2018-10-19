class AdditionalArchitect < ActiveRecord::Base
  belongs_to  :property, foreign_key: :propid 

  self.table_name = "additionalarchitect"
  
end
