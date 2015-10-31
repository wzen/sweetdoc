class CreateUserCodingTrees < ActiveRecord::Migration
  def change
    create_table :user_coding_trees do |t|
      t.integer :user_id, null: false
      t.text :node_path, null: false
      t.string :user_coding_id
      t.boolean :del_flg, default: false

      t.timestamps
    end

    add_index :user_coding_trees, :user_id
  end
end
