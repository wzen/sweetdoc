class CreateCommonActionEvents < ActiveRecord::Migration
  def change
    create_table :common_action_events do |t|
      t.integer :user_auth_strength_min, :null => false
      t.integer :common_action_event_target_type_id, :null => false
      t.integer :action_event_type_id, :null => false
      t.integer :action_event_change_type_id, :null => false
      t.text :method_name, :null => false
      t.text :options
      t.text :desc

      t.timestamps
    end
  end
end
