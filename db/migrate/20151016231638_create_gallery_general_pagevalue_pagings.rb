class CreateGalleryGeneralPagevaluePagings < ActiveRecord::Migration
  def change
    create_table :gallery_general_pagevalue_pagings do |t|
      t.integer :gallery_id, :null => false
      t.integer :page_num, :null => false
      t.integer :gallery_general_pagevalue_id, :null => false
      t.boolean :del_flg, :null => false, :default => false

      t.timestamps
    end
  end
end
