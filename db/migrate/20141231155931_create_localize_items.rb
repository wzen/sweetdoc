class CreateLocalizeItems < ActiveRecord::Migration
  def change
    create_table :localize_items do |t|
      t.integer :item_id, :null => false
      t.integer :locale_id, :null => false
      t.string :item_name, :null => false

      t.timestamps
    end
  end
end
