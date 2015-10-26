class CreateGalleryCodings < ActiveRecord::Migration
  def change
    create_table :gallery_codings do |t|
      t.string :name, null: false
      t.integer :public_type, null: false
      t.integer :lang_type, null: false
      t.text :code, null: false
      t.integer :version, default: 1
      t.boolean :del_flg, default: false
      t.timestamps
    end
  end
end
