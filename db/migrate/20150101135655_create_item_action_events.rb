class CreateItemActionEvents < ActiveRecord::Migration
  def change
    create_table :item_action_events do |t|
      t.integer :item_id, :null => false
      t.integer :action_event_type_id, :null => false
      t.integer :action_animation_type_id, :null => false
      t.string :method_name, :null => false
      t.text :scroll_enabled_direction
      t.text :scroll_forward_direction
      t.boolean :is_default, :default => false
      t.text :options

      t.timestamps
    end
  end
end
