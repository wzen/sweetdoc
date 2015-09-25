class CreateGalleryInstancePagevalues < ActiveRecord::Migration
  def change
    create_table :gallery_instance_pagevalues do |t|
      t.integer :page_num, :null => false
      t.text :data

      t.timestamps
    end
  end
end
