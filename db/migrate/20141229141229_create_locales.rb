class CreateLocales < ActiveRecord::Migration
  def change
    create_table :locales do |t|
      t.integer :locale_id
      t.string :locale_name
      t.integer :order

      t.timestamps
    end
  end
end
