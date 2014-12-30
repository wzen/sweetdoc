class CreateActionEvents < ActiveRecord::Migration
  def change
    create_table :action_events do |t|
      t.integer :item_type, :null => false
      t.string :mothod_name, :null => false
      t.integer :event_type_id, :null => false
      t.integer :locale_id, :null => false
      t.text :desc

      t.timestamps
    end
  end
end
