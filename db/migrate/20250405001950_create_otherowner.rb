class CreateOtherowner < ActiveRecord::Migration[7.1]
  def change
    create_table :otherowner do |t|
      t.integer :id, null: false
      t.integer :propid, null: false
      t.string :name, limit: 128, null: false
      t.string :years, limit: 32
      t.string :yearflag, limit: 1
    end
  end
end
