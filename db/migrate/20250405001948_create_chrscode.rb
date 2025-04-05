class CreateChrscode < ActiveRecord::Migration[7.1]
  def change
    create_table :chrscode do |t|
      t.string :code, limit: 6, null: false
    end
  end
end
