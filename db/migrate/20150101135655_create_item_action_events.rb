class CreateItemActionEvents < ActiveRecord::Migration
  def change
    create_table :item_action_events do |t|
      t.integer :item_id, :null => false
      t.integer :action_event_type_id, :null => false
      t.integer :action_event_change_type_id, :null => false
      t.string :method_name, :null => false
      t.text :options
      t.text :desc

      t.timestamps
    end
  end
end
