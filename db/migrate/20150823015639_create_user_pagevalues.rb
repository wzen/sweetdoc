class CreateUserPagevalues < ActiveRecord::Migration
  def change
    create_table :user_pagevalues do |t|
      t.integer :user_project_map_id, :null => false
      t.integer :setting_pagevalue_id
      t.boolean :del_flg, :default => false

      t.timestamps
    end
  end
end
