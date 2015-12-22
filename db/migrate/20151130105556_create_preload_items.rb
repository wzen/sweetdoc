class CreatePreloadItems < ActiveRecord::Migration
  def change
    create_table :preload_items do |t|
      t.string :title, null: false
      t.text :caption
      t.string :dist_token, null: false
      t.integer :create_user_id, :null => false
      t.integer :modify_user_id, :null => false

      t.timestamps
    end
  end
end
