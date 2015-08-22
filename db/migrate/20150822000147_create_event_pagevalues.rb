class CreateEventPagevalues < ActiveRecord::Migration
  def change
    create_table :event_pagevalues do |t|
      t.integer :user_id, :null => false
      t.string :obj_id, :null => false
      t.integer :common_event_id, :null => false
      t.integer :item_id, :null => false
      t.integer :chapter_num, :null => false
      t.integer :screen_num, :null => false
      t.boolean :is_common_event, :null => false
      t.text :data

      t.timestamps
    end
  end
end
