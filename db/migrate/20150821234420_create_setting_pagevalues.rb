class CreateSettingPagevalues < ActiveRecord::Migration
  def change
    create_table :setting_pagevalues do |t|
      t.text :data

      t.timestamps
    end
  end
end
