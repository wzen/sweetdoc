class CreateLocalizeItemActionEvents < ActiveRecord::Migration
  def change
    create_table :localize_item_action_events do |t|
      t.integer :item_action_event_id, :null => false
      t.integer :locale_id, :null => false
      t.text :options

      t.timestamps
    end
  end
end
