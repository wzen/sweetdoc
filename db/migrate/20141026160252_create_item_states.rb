class CreateItemStates < ActiveRecord::Migration
  def change
    create_table :item_states do |t|
      t.integer :user_id, :null => false
      t.integer :table_id, :null => false
      t.string :item_id, :null => false
      t.string :contents

      t.timestamps
    end
  end
end
