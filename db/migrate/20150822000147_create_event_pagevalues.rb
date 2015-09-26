class CreateEventPagevalues < ActiveRecord::Migration
  def change
    create_table :event_pagevalues do |t|
      t.text :data
      t.integer :retain, :null => false, :default => 1
      t.boolean :del_flg, :null => false, :default => false

      t.timestamps
    end
  end
end
