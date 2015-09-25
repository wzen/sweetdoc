class CreateGalleries < ActiveRecord::Migration
  def change
    create_table :galleries do |t|
      t.integer :user_id, :null => false
      t.integer :gallery_tags_id
      t.integer :gallery_instance_pagevalue_paging_id
      t.integer :gallery_event_pagevalue_paging_id

      t.timestamps
    end
  end
end
