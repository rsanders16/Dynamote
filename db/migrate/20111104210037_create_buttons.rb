class CreateButtons < ActiveRecord::Migration
  def change
    create_table :buttons do |t|
      t.integer "size_x", :limit=>10000, :null=>false
      t.integer "size_y", :limit=>10000, :null=>false
      t.integer "pos_x", :limit=>10000, :null=>false
      t.integer "pos_y", :limit=>10000, :null=>false
      t.integer "icon_id", :foreign_key=>"icon_id", :null=>false
      t.integer "macro_id", :foreign_key=>"macro_id", :null=>false
      t.integer "remote_id", :foreign_key=>"remote_id", :null=>false
      t.timestamps
    end
  end
end
