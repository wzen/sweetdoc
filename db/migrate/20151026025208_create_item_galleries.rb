class CreateItemGalleries < ActiveRecord::Migration
  def change
    create_table :item_galleries do |t|
      t.string :access_token, null: false
      t.integer :created_user_id, null: false
      t.string :title, null: false
      t.text :caption
      t.string :class_name, null: false
      t.integer :public_type, null: false
      t.string :file_name, null: false
      t.integer :version, default: 1
      t.boolean :del_flg, default: false
      t.timestamps
    end
  end
end
