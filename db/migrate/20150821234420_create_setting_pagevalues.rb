class CreateSettingPagevalues < ActiveRecord::Migration
  def change
    create_table :setting_pagevalues do |t|
      t.integer :user_id, :null => false
      t.integer :key_id, :null => false
      t.text :value

      t.timestamps
    end
  end
end
