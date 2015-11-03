class CreateGalleryCodings < ActiveRecord::Migration
  def change
    create_table :gallery_codings do |t|
      t.integer :created_user_id, null: false
      t.string :class_name, null: false
      t.integer :category
      t.integer :public_type, null: false
      #t.integer :lang_type, null: false
      t.string :file_name, null: false
      t.integer :version, default: 1
      t.boolean :del_flg, default: false
      t.timestamps
    end
  end
end
