class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :id
      t.string :name
      t.string :username
      t.string :password
      t.boolean :is_admin
      t.string :locale
      t.string :theme
      t.timestamps
    end
  end
end
