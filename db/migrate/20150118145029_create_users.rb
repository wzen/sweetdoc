class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :null => false
      t.integer :user_auth_id, :null => false
      t.string :mail

      t.timestamps
    end
  end
end
