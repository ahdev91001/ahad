class CreateApn < ActiveRecord::Migration[7.1]
  def change
    create_table :apn do |t|
      t.integer :id, null: false
      t.integer :propid, null: false
      t.string :parcel, limit: 16, null: false
    end
  end
end
