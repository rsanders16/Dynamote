class CreateRemotes < ActiveRecord::Migration
  def change
    create_table :remotes do |t|
      t.string "name", :limit=>100, :null=>false
      t.integer "remote_type_id", :foreign_key=>"remote_type_id", :null=>false
      t.integer "account_id", :foreign_key=>"account_id", :null=>false
      t.timestamps
    end
  end
end
