class CreateActionEvents < ActiveRecord::Migration
  def change
    create_table :action_events do |t|
      t.integer :item_type
      t.string :mothod_name
      t.integer :event_type_id
      t.integer :locale_id
      t.text :desc

      t.timestamps
    end
  end
end
