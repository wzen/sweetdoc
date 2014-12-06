class CreateItemStates < ActiveRecord::Migration
  def change
    create_table :item_states do |t|
      t.integer :user_id, :null => false
      t.text :state
      t.text :css_info
      t.timestamps
    end
  end
end
