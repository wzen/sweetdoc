class CreateUserPagevalues < ActiveRecord::Migration
  def change
    create_table :user_pagevalues do |t|
      t.integer :user_id, :null => false
      t.integer :setting_pagevalue_id
      t.boolean :del_flg, :null => false, :default => false

      t.timestamps
    end
  end
end
