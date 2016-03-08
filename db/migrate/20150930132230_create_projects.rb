class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.integer :screen_width, :null => false
      t.integer :screen_height, :null => false
      t.boolean :is_sample, default: false
      t.boolean :del_flg, :default => false

      t.timestamps
    end
  end
end
