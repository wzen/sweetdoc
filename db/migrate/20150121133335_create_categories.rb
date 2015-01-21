class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :category_name, :null => false
      t.integer :rating

      t.timestamps
    end
  end
end
