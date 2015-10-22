class CreateGalleries < ActiveRecord::Migration
  def change
    create_table :galleries do |t|
      t.string :access_token, null: false, limit: 30
      t.string :title, null: false
      t.text :caption
      t.binary :thumbnail_img, limit: 10.megabyte
      t.string :thumbnail_img_contents_type
      t.integer :screen_width, null: false
      t.integer :screen_height, null: false
      t.integer :page_max, default: 1
      t.boolean :show_guide, default: true
      t.boolean :show_page_num, default: false
      t.boolean :show_chapter_num, default: false
      t.boolean :del_flg, :default => false

      t.timestamps
    end

    add_index :galleries, :access_token,         unique: true
  end
end
