class CreateProjectGalleryMaps < ActiveRecord::Migration
  def change
    create_table :project_gallery_maps do |t|
      t.integer :project_id, :null => false
      t.integer :gallery_id, :null => false
      t.boolean :del_flg, :default => false

      t.timestamps
    end
  end
end
