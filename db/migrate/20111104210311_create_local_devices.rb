class CreateLocalDevices < ActiveRecord::Migration
  def change
    create_table :local_devices do |t|
      t.string "name", :limit=>100, :null=>false
      t.integer "supported_device_id", :foreign_key=>"supported_device_id"
      t.timestamps
    end
  end
end
