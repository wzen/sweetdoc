class CreateGalleries < ActiveRecord::Migration
  def change
    create_table :galleries do |t|
      t.string :access_token, null: false
      t.string :title, null: false
      t.text :caption
      t.string :thumbnail_img
      t.string :thumbnail_url
      t.integer :thumbnail_img_width
      t.integer :thumbnail_img_height
      t.integer :screen_width
      t.integer :screen_height
      t.integer :page_max, default: 1
      t.boolean :show_guide, default: true
      t.boolean :show_page_num, default: false
      t.boolean :show_chapter_num, default: false
      t.integer :created_user_id, null: false
      t.integer :version, default: 1
      t.boolean :del_flg, :default => false

      t.timestamps
    end

    add_index :galleries, :access_token,         unique: true
    add_index :galleries, :created_user_id
  end
end
