class CreateAvailibleIcons < ActiveRecord::Migration
  def change
    create_table :availible_icons do |t|
      t.string "name", :limit=>100
      t.boolean "user_added", :default=>false
      t.string "hex_code", :limit=>5000 ,:null=>false
      t.timestamps
    end
  end
end
