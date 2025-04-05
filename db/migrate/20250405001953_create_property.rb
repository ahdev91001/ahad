class CreateProperty < ActiveRecord::Migration[7.1]
  def change
    create_table :property do |t|
      t.string :streetnumberbegin, limit: 16
    end
  end
end
