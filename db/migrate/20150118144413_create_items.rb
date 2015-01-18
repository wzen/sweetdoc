class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :create_user_id, :null => false
      t.integer :modify_user_id, :null => false
      t.string :name, :null => false
      t.string :src_name, :null => false

      t.timestamps
    end
  end
end
