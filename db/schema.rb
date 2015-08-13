# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150716084839) do

  create_table "categories", force: true do |t|
    t.string   "category_name", null: false
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "common_action_events", force: true do |t|
    t.integer  "common_action_id",                   null: false
    t.integer  "user_auth_strength_min",             null: false
    t.integer  "common_action_event_target_type_id", null: false
    t.integer  "action_event_type_id",               null: false
    t.integer  "action_animation_type_id",           null: false
    t.text     "method_name",                        null: false
    t.text     "options"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "common_actions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_action_events", force: true do |t|
    t.integer  "item_id",                                  null: false
    t.integer  "action_event_type_id",                     null: false
    t.integer  "action_animation_type_id",                 null: false
    t.string   "method_name",                              null: false
    t.boolean  "is_default",               default: false
    t.text     "options"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_categories", force: true do |t|
    t.integer  "item_id",     null: false
    t.integer  "category_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_states", force: true do |t|
    t.integer  "user_id",    null: false
    t.text     "state"
    t.text     "css_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.integer  "draw_type",      null: false
    t.string   "name",           null: false
    t.string   "src_name",       null: false
    t.text     "css_temp"
    t.integer  "create_user_id", null: false
    t.integer  "modify_user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locales", force: true do |t|
    t.string   "i18n_locale", null: false
    t.string   "locale_name", null: false
    t.integer  "order",       null: false
    t.string   "domain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "localize_common_action_events", force: true do |t|
    t.integer  "common_action_event_id"
    t.integer  "locale_id"
    t.text     "options"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "localize_item_action_events", force: true do |t|
    t.integer  "item_action_event_id", null: false
    t.integer  "locale_id",            null: false
    t.text     "options"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "localize_items", force: true do |t|
    t.integer  "item_id",    null: false
    t.integer  "locale_id",  null: false
    t.string   "item_name",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parts", force: true do |t|
    t.integer  "type_cd",     null: false
    t.integer  "sub_type_cd"
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_auths", force: true do |t|
    t.string   "name",           null: false
    t.integer  "strength_order", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name",         null: false
    t.integer  "user_auth_id", null: false
    t.string   "mail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
