class CreateLocales < ActiveRecord::Migration
  def change
    create_table :locales do |t|
      t.string :i18n_locale, :null => false
      t.string :locale_name, :null => false
      t.integer :order, :null => false
      t.string :domain

      t.timestamps
    end
  end
end
