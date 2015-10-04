class CreateGeneralPagevaluePagings < ActiveRecord::Migration
  def change
    create_table :general_pagevalue_pagings do |t|
      t.integer :user_pagevalue_id, :null => false
      t.integer :page_num, :null => false
      t.integer :general_pagevalue_id, :null => false
      t.boolean :del_flg, :default => false

      t.timestamps
    end
  end
end
