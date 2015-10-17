class CreateGeneralCommonPagevalues < ActiveRecord::Migration
  def change
    create_table :general_common_pagevalues do |t|
      t.integer :user_pagevalue_id, :null => false
      t.text :data
      t.boolean :del_flg, :default => false

      t.timestamps
    end
  end
end
