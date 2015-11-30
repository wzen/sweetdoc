class CreatePreloadItems < ActiveRecord::Migration
  def change
    create_table :preload_items do |t|
      t.string :title, null: false
      t.text :caption
      t.string :class_name, null: false
      t.string :file_name, null: false
      t.integer :create_user_id, :null => false
      t.integer :modify_user_id, :null => false

      t.timestamps
    end
  end
end
