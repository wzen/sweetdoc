class CreateEventPagevalues < ActiveRecord::Migration
  def change
    create_table :event_pagevalues do |t|
      t.integer :user_id, :null => false
      t.text :data

      t.timestamps
    end
  end
end
