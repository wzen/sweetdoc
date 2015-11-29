class CreateUserItemGalleryMaps < ActiveRecord::Migration
  def change
    create_table :user_item_gallery_maps do |t|
      t.integer :user_id, null: false
      t.integer :item_gallery_id, null: false
      t.boolean :del_flg, default: false
      t.timestamps
    end

    add_index :user_item_gallery_maps, [:user_id, :item_gallery_id], unique: true
  end
end
