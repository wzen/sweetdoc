class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title, null: false, limit: 100
      t.boolean :is_sample, default: false
      t.boolean :del_flg, :default => false

      t.timestamps
    end
  end
end
