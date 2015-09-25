class CreateGalleryInstancePagevaluePagings < ActiveRecord::Migration
  def change
    create_table :gallery_instance_pagevalue_pagings do |t|
      t.integer :gallery_id, :null => false
      t.integer :page_num, :null => false
      t.integer :gallery_instance_pagevalue_id, :null => false

      t.timestamps
    end
  end
end
