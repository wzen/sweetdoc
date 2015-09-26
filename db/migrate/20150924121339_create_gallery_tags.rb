class CreateGalleryTags < ActiveRecord::Migration
  def change
    create_table :gallery_tags do |t|
      t.string :name, :null => false
      t.integer :weight, :defaults => 0
      t.boolean :del_flg, :null => false, :default => false

      t.timestamps
    end
  end
end
