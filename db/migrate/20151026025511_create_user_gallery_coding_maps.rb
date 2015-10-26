class CreateUserGalleryCodingMaps < ActiveRecord::Migration
  def change
    create_table :user_gallery_coding_maps do |t|
      t.integer :user_id, null: false
      t.integer :gallery_coding_id, null: false
      t.boolean :del_flg, default: false
      t.timestamps
    end

    add_index :user_gallery_coding_maps, [:user_id, :gallery_coding_id], unique: true
  end
end
