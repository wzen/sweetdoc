class CreateGalleryTags < ActiveRecord::Migration
  def change
    create_table :gallery_tags do |t|
      t.string :name, :null => false
      t.integer :weight, :defaults => 0

      t.timestamps
    end
  end
end
