class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer :id
      t.string :name
      t.string :device_type
      t.string :model_number
      t.boolean :is_hidden
      t.timestamps
    end
  end
end
