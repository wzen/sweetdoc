class CreateGalleryBookmarks < ActiveRecord::Migration
  def change
    create_table :gallery_bookmarks do |t|
      t.integer :user_id, :null => false
      t.integer :gallery_id, :null => false
      t.text :note

      t.timestamps
    end
  end
end
