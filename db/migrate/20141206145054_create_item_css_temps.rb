class CreateItemCssTemps < ActiveRecord::Migration
  def change
    create_table :item_css_temps do |t|
      t.integer :item_type, :null => false
      t.text :contents
      t.timestamps
    end
  end
end
