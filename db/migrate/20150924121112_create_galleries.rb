class CreateGalleries < ActiveRecord::Migration
  def change
    create_table :galleries do |t|
      t.string :title, :null => false
      t.text :caption
      t.binary :thumbnail_img
      t.integer :screen_width, :null => false
      t.integer :screen_height, :null => false
      t.boolean :del_flg, :default => false

      t.timestamps
    end
  end
end
