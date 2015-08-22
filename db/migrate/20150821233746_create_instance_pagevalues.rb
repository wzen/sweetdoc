class CreateInstancePagevalues < ActiveRecord::Migration
  def change
    create_table :instance_pagevalues do |t|
      t.integer :user_id, :null => false
      t.string :obj_id, :null => false
      t.integer :common_event_id
      t.integer :item_id
      t.text :data

      t.timestamps
    end
  end
end
