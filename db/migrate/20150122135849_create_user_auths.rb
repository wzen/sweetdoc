class CreateUserAuths < ActiveRecord::Migration
  def change
    create_table :user_auths do |t|
      t.string :name, :null => false
      t.integer :strength_order, :null => false

      t.timestamps
    end
  end
end
