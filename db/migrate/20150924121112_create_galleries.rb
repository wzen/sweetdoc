class CreateGalleries < ActiveRecord::Migration
  def change
    create_table :galleries do |t|
      t.integer :user_id, :null => false
      t.string :title
      t.text :caption
      t.binary :thumbnail_img
      t.boolean :del_flg, :null => false, :default => false

      t.timestamps
    end
  end
end
