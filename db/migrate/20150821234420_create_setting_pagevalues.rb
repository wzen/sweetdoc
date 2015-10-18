class CreateSettingPagevalues < ActiveRecord::Migration
  def change
    create_table :setting_pagevalues do |t|
      t.boolean :autosave, null: false
      t.float :autosave_time
      t.boolean :grid_enable, null: false
      t.integer :grid_step
      t.boolean :del_flg, :default => false

      t.timestamps
    end
  end
end
