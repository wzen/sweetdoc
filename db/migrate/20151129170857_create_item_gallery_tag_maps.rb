class CreateItemGalleryTagMaps < ActiveRecord::Migration
  def change
    create_table :item_gallery_tag_maps do |t|
      t.integer :item_gallery_id, null: false
      t.integer :item_gallery_tag_id, null: false
      t.boolean :del_flg, default: false

      t.timestamps
    end
  end
end
