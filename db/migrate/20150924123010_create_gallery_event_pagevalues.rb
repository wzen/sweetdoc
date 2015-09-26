class CreateGalleryEventPagevalues < ActiveRecord::Migration
  def change
    create_table :gallery_event_pagevalues do |t|
      t.integer :page_num, :null => false
      t.text :data
      t.integer :retain, :null => false, :default => 1
      t.boolean :del_flg, :null => false, :default => false

      t.timestamps
    end
  end
end
