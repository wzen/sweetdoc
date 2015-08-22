class CreateLocalizeCommonActionEvents < ActiveRecord::Migration
  def change
    create_table :localize_common_action_events do |t|
      t.integer :common_action_event_id, :null => false
      t.integer :locale_id, :null => false
      t.text :options

      t.timestamps
    end
  end
end
