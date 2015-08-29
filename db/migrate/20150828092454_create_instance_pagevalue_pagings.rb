class CreateInstancePagevaluePagings < ActiveRecord::Migration
  def change
    create_table :instance_pagevalue_pagings do |t|
      t.integer :paging_num, :null => false
      t.integer :instance_pagevalue_id, :null => false

      t.timestamps
    end
  end
end
