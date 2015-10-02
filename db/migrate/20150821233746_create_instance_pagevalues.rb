class CreateInstancePagevalues < ActiveRecord::Migration
  def change
    create_table :instance_pagevalues do |t|
      t.text :data
      t.integer :retain, :null => false, :default => 1
      t.boolean :del_flg, :default => false

      t.timestamps
    end
  end
end
