class CreateBuildingpermit < ActiveRecord::Migration[7.1]
  def change
    create_table :buildingpermit do |t|
      t.integer :id, null: false
      t.integer :propid, null: false
      t.string :permit, limit: 32, null: false
      t.string :year, limit: 32
      t.string :yearflag, limit: 1
    end
  end
end
