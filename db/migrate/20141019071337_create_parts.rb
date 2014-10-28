class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.integer :type_cd, :null => false
      t.integer :sub_type_cd
      t.text :contents

      t.timestamps
    end
  end
end
