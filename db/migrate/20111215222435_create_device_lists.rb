class CreateDeviceLists < ActiveRecord::Migration
  def change
    create_table :device_lists do |t|
      t.string :device_name
      t.string :device_type
      t.string :modnum

      t.timestamps
    end
  end
end
