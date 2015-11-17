class CreateUserGalleryFootprints < ActiveRecord::Migration
  def change
    create_table :user_gallery_footprints do |t|
      t.integer :user_id, null: false
      t.integer :gallery_id, null:false
      t.text :data
      t.boolean :del_flg, default: false
      t.timestamps
    end

    add_index :user_gallery_footprints, [:user_id, :gallery_id], unique: true
  end
end
