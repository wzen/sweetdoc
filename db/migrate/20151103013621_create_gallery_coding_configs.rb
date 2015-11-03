class CreateGalleryCodingConfigs < ActiveRecord::Migration
  def change
    create_table :gallery_coding_configs do |t|
      t.integer :gallery_coding_id, null: false
      t.integer :config_type, null: false
      t.string :header
      t.string :label
      t.integer :design_type
      t.integer :event_type
      t.string :vars
      t.string :option
      t.integer :order, null: false
      t.boolean :del_flg, default: false
      t.timestamps
    end
    add_index :gallery_coding_configs, :gallery_coding_id
  end
end
