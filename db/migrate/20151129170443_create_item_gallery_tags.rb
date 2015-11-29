class CreateItemGalleryTags < ActiveRecord::Migration
  def change
    create_table :item_gallery_tags do |t|
      t.string :name, null: false
      t.integer :weight, default: 0
      t.string :category
      t.boolean :del_flg, default: false

      t.timestamps
    end
  end
end
