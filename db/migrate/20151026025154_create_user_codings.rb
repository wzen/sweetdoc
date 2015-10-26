class CreateUserCodings < ActiveRecord::Migration
  def change
    create_table :user_codings do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.integer :lang_type, null: false
      t.text :code, null: false

      t.timestamps
    end
  end
end
