class CreateAlteration < ActiveRecord::Migration[7.1]
  def change
    create_table :alteration do |t|
      t.integer :id, null: false
      t.integer :propid, null: false
      t.integer :cost
      t.string :description, limit: 128
      t.string :year, limit: 32
      t.string :yearflag, limit: 1
    end
  end
end
