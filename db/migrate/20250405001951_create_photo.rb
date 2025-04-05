class CreatePhoto < ActiveRecord::Migration[7.1]
  def change
    create_table :photo do |t|
      t.integer :id, null: false
      t.integer :propid, null: false
      t.string :filename, limit: 64, null: false
      t.string :description, limit: 128
    end
  end
end
