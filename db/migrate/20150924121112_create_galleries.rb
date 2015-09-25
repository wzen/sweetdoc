class CreateGalleries < ActiveRecord::Migration
  def change
    create_table :galleries do |t|
      t.integer :user_id, :null => false
      t.string :title
      t.text :caption
      t.timestamps
    end
  end
end
