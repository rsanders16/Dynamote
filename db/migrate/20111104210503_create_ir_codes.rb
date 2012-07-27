class CreateIrCodes < ActiveRecord::Migration
  def change
    create_table :ir_codes do |t|
      t.integer "supported_device_id", :foreign_key=>"supported_device_id"
      t.string "code_name", :limit=>100, :null=>false
      t.boolean "user_added", :default=>false
      t.timestamps
    end
  end
end
