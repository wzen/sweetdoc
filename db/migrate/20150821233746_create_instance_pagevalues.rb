class CreateInstancePagevalues < ActiveRecord::Migration
  def change
    create_table :instance_pagevalues do |t|
      t.text :data
      t.boolean :del_flg, :default => false

      t.timestamps
    end
  end
end
