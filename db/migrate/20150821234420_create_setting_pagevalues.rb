class CreateSettingPagevalues < ActiveRecord::Migration
  def change
    create_table :setting_pagevalues do |t|
      t.text :data
      t.boolean :del_flg, :null => false, :default => false

      t.timestamps
    end
  end
end
