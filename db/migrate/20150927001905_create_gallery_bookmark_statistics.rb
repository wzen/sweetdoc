class CreateGalleryBookmarkStatistics < ActiveRecord::Migration
  def change
    create_table :gallery_bookmark_statistics do |t|
      t.integer :gallery_id, null: false
      t.integer :count, default: 0
      t.date :view_day
      t.boolean :del_flg, default: false

      t.timestamps
    end
  end
end
