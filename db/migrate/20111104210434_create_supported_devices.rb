class CreateSupportedDevices < ActiveRecord::Migration
  def change
    create_table :supported_devices do |t|
      t.string "name", :limit=>100, :null=>false
      t.string "manufacturer", :limit=>100
      t.string "model", :limit=>100
      t.timestamps
    end
  end
end
