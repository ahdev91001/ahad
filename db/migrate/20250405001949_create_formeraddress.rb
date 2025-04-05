class CreateFormeraddress < ActiveRecord::Migration[7.1]
  def change
    create_table :formeraddress do |t|
      t.integer :id, null: false
      t.integer :propid, null: false
      t.string :address1, limit: 128, null: false
      t.string :address2, limit: 128, null: false
      t.string :years, limit: 64
      t.string :yearflag, limit: 1
    end
  end
end
