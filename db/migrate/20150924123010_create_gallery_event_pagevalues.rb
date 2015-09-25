class CreateGalleryEventPagevalues < ActiveRecord::Migration
  def change
    create_table :gallery_event_pagevalues do |t|
      t.integer :page_num, :null => false
      t.text :data

      t.timestamps
    end
  end
end
