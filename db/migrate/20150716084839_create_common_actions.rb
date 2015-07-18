class CreateCommonActions < ActiveRecord::Migration
  def change
    create_table :common_actions do |t|
      t.string :name

      t.timestamps
    end
  end
end
