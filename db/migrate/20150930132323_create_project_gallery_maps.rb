class CreateProjectGalleryMaps < ActiveRecord::Migration
  def change
    create_table :project_gallery_maps do |t|
      t.integer :user_project_map_id, :null => false
      t.integer :gallery_id, :null => false
      t.boolean :del_flg, :default => false

      t.timestamps
    end
    add_index :project_gallery_maps, [:user_project_map_id, :gallery_id], unique: true
  end
end
