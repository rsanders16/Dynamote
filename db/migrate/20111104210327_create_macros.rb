class CreateMacros < ActiveRecord::Migration
  def change
    create_table :macros do |t|
      t.string "name", :limit=>100, :null=>false
      t.integer "remote_id", :foreign_key=>"remote_id"
      t.timestamps
    end
  end
end
