class CreateItemGalleryUsingStatistics < ActiveRecord::Migration
  def change
    create_table :item_gallery_using_statistics do |t|
      t.integer :item_gallery_id, null: false
      t.integer :count, default: 0
      t.boolean :del_flg, default: false

      t.timestamps
    end
  end
end
