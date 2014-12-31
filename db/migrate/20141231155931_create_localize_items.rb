class CreateLocalizeItems < ActiveRecord::Migration
  def change
    create_table :localize_items do |t|

      t.timestamps
    end
  end
end
