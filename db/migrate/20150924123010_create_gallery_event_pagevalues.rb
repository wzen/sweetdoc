class CreateGalleryEventPagevalues < ActiveRecord::Migration
  def change
    create_table :gallery_event_pagevalues do |t|
      t.text :data
      t.boolean :del_flg, :null => false, :default => false

      t.timestamps
    end
  end
end
