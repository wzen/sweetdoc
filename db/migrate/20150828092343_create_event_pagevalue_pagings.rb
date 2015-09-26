class CreateEventPagevaluePagings < ActiveRecord::Migration
  def change
    create_table :event_pagevalue_pagings do |t|
      t.integer :user_pagevalue_id, :null => false
      t.integer :page_num, :null => false
      t.integer :event_pagevalue_id, :null => false
      t.boolean :del_flg, :null => false, :default => false

      t.timestamps
    end
  end
end
