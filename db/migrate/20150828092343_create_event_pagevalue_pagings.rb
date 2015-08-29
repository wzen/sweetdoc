class CreateEventPagevaluePagings < ActiveRecord::Migration
  def change
    create_table :event_pagevalue_pagings do |t|
      t.integer :paging_num, :null => false
      t.integer :event_pagevalue_id, :null => false

      t.timestamps
    end
  end
end
