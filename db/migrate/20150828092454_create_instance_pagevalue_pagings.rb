class CreateInstancePagevaluePagings < ActiveRecord::Migration
  def change
    create_table :instance_pagevalue_pagings do |t|
      t.integer :user_pagevalue_id, :null => false
      t.integer :page_num, :null => false
      t.integer :instance_pagevalue_id, :null => false
      t.boolean :del_flg, :null => false, :default => false

      t.timestamps
    end
  end
end
