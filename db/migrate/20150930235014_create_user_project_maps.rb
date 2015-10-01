class CreateUserProjectMaps < ActiveRecord::Migration
  def change
    create_table :user_project_maps do |t|
      t.integer :user_id, :null => false
      t.integer :project_id, :null => false
      t.boolean :del_flg, :default => false

      t.timestamps
    end
  end
end
