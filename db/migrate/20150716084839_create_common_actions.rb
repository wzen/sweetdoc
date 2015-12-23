class CreateCommonActions < ActiveRecord::Migration
  def change
    create_table :common_actions do |t|
      t.string :title, null: false
      t.string :dist_token, null: false

      t.timestamps
    end
  end
end
