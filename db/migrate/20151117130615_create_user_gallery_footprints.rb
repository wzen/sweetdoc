class CreateUserGalleryFootprints < ActiveRecord::Migration
  def change
    create_table :user_gallery_footprints do |t|
      t.integer :user_id
      t.integer :gallery_id
      t.integer :page_num
      # カラム随時追加

      t.boolean :del_flg, default: false
      t.timestamps
    end

    add_index :user_gallery_footprints, [:user_id, :gallery_id], unique: true, name: 'user_gallery_footprints_index'
  end
end
