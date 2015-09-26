class CreateGalleryTagMaps < ActiveRecord::Migration
  def change
    create_table :gallery_tag_maps do |t|
      t.integer :gallery_id, :null => false
      t.integer :gallery_tag_id, :null => false
      t.boolean :del_flg, :null => false, :default => false

      t.timestamps
    end
  end
end
