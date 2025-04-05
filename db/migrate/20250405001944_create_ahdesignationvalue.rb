class CreateAhdesignationvalue < ActiveRecord::Migration[7.1]
  def change
    create_table :ahdesignationvalue do |t|
      t.string :value, limit: 128, null: false
    end
  end
end
