class CreateUserGalleryFootprintPagings < ActiveRecord::Migration
  def change
    create_table :user_gallery_footprint_pagings do |t|
      t.integer :user_id, :null => false
      t.integer :gallery_id, :null => false
      t.integer :page_num, :null => false
      t.integer :user_gallery_footprint_pagevalue_id, :null => false
      t.boolean :del_flg, :null => false, :default => false

      t.timestamps
    end

    add_index :user_gallery_footprint_pagings, [:user_id, :gallery_id, :page_num], unique: true
  end
end
