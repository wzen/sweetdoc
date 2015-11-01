class CreateUserCodings < ActiveRecord::Migration
  def change
    create_table :user_codings do |t|
      t.integer :user_id, null: false
      t.string :lang_type, null: false
      t.string :code_filename, null: false, limit: 15
      t.boolean :del_flg, default: false
      t.timestamps
    end
  end
end
