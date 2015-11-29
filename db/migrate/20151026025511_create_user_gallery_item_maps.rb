class CreateUserGalleryItemMaps < ActiveRecord::Migration
  def change
    create_table :user_gallery_item_maps do |t|
      t.integer :user_id, null: false
      t.integer :gallery_item_id, null: false
      t.boolean :del_flg, default: false
      t.timestamps
    end

    add_index :user_gallery_item_maps, [:user_id, :gallery_item_id], unique: true
  end
end
