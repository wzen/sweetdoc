class CreateItemActionEvents < ActiveRecord::Migration
  def change
    create_table :item_action_events do |t|
      t.integer :item_type, :null => false
      t.integer :event_type_id, :null => false
      t.string :mothod_name, :null => false

      t.timestamps
    end
  end
end
