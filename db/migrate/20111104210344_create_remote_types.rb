class CreateRemoteTypes < ActiveRecord::Migration
  def change
    create_table :remote_types do |t|
      t.integer "size_x", :limit=>10000, :null=>false
      t.integer "size_y", :limit=>10000, :null=>false
      t.integer "pixel_density", :limit=>10000, :null=>false
      t.timestamps
    end
  end
end
