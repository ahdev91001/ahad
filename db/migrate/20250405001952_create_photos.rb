class CreatePhotos < ActiveRecord::Migration[7.1]
  def change
    create_table :photos do |t|
      t.integer :id, null: false
      t.integer :propid, null: false
      t.string :filename, limit: 45
      t.string :description
    end
  end
end
