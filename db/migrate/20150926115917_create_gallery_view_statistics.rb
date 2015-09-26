class CreateGalleryViewStatistics < ActiveRecord::Migration
  def change
    create_table :gallery_view_statistics do |t|
      t.integer :gallery_id, :null => false
      t.integer :count, :default => 0
      t.date :view_day

      t.timestamps
    end
  end
end
