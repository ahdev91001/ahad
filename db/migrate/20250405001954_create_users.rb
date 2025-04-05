class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.string :password_digest
      t.string :remember_digest
      t.boolean :admin
    end
  end
end
