class CreateInstancePagevalues < ActiveRecord::Migration
  def change
    create_table :instance_pagevalues do |t|
      t.text :data

      t.timestamps
    end
  end
end
