class CreateItemImages < ActiveRecord::Migration
  def change
    create_table :item_images do |t|
      t.integer :user_project_map_id, null: false
      t.integer :gallery_id
      t.string :item_obj_id, null: false
      t.string :event_dist_id
      t.string :file_path
      t.text :link_url
      t.boolean :del_flg, default: false

      t.timestamps
    end

    add_index :item_images, :user_project_map_id, name: 'item_images_index1'
    add_index :item_images, [:gallery_id, :item_obj_id], name: 'item_images_index2'
  end
end
