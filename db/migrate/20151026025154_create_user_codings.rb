class CreateUserCodings < ActiveRecord::Migration
  def change
    create_table :user_codings do |t|
      t.integer :user_id, null: false
      t.string :lang_type, null: false
      t.text :code, null: false
      t.boolean :del_flg, default: false
      t.timestamps
    end
  end
end
