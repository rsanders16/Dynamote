class CreateMacroActions < ActiveRecord::Migration
  def change
    create_table :macro_actions do |t|
      t.integer "step_number", :limit=>100, :null=>false
      t.integer "ir_code_id", :foreign_key=>"ir_code_id"
      t.integer "macro_id", :foreign_key=>"macro_id", :null=>false
      t.timestamps
    end
  end
end
