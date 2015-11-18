class CreateUserGalleryFootprintPagevalues < ActiveRecord::Migration
  def change
    create_table :user_gallery_footprint_pagevalues do |t|
      t.text :data
      t.boolean :del_flg, default: false
      t.timestamps
    end
  end
end
