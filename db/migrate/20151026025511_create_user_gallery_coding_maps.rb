class CreateUserGalleryCodingMaps < ActiveRecord::Migration
  def change
    create_table :user_gallery_coding_maps do |t|
      t.integer :user_id, null: false
      t.integer :gallery_coding_id, null: false
      t.timestamps
    end
  end
end
