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

ActiveRecord::Schema.define(version: 20150927001905) do

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
    t.text     "scroll_enabled_direction"
    t.text     "scroll_forward_direction"
    t.text     "options"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "common_actions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_pagevalue_pagings", force: true do |t|
    t.integer  "user_pagevalue_id",                  null: false
    t.integer  "page_num",                           null: false
    t.integer  "event_pagevalue_id",                 null: false
    t.boolean  "del_flg",            default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_pagevalues", force: true do |t|
    t.text     "data"
    t.integer  "retain",     default: 1,     null: false
    t.boolean  "del_flg",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "galleries", force: true do |t|
    t.integer  "user_id",                       null: false
    t.string   "title"
    t.text     "caption"
    t.string   "thumbnail_url"
    t.boolean  "del_flg",       default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gallery_bookmark_statistics", force: true do |t|
    t.integer  "gallery_id",             null: false
    t.integer  "count",      default: 0
    t.date     "view_day"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gallery_bookmarks", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "gallery_id", null: false
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gallery_event_pagevalue_pagings", force: true do |t|
    t.integer  "gallery_id",                                 null: false
    t.integer  "page_num",                                   null: false
    t.integer  "gallery_event_pagevalue_id",                 null: false
    t.boolean  "del_flg",                    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gallery_event_pagevalues", force: true do |t|
    t.integer  "page_num",                   null: false
    t.text     "data"
    t.integer  "retain",     default: 1,     null: false
    t.boolean  "del_flg",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gallery_instance_pagevalue_pagings", force: true do |t|
    t.integer  "gallery_id",                                    null: false
    t.integer  "page_num",                                      null: false
    t.integer  "gallery_instance_pagevalue_id",                 null: false
    t.boolean  "del_flg",                       default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gallery_instance_pagevalues", force: true do |t|
    t.integer  "page_num",                   null: false
    t.text     "data"
    t.integer  "retain",     default: 1,     null: false
    t.boolean  "del_flg",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gallery_tag_maps", force: true do |t|
    t.integer  "gallery_id",                     null: false
    t.integer  "gallery_tag_id",                 null: false
    t.boolean  "del_flg",        default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gallery_tags", force: true do |t|
    t.string   "name",                       null: false
    t.integer  "weight"
    t.boolean  "del_flg",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gallery_view_statistics", force: true do |t|
    t.integer  "gallery_id",             null: false
    t.integer  "count",      default: 0
    t.date     "view_day"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instance_pagevalue_pagings", force: true do |t|
    t.integer  "user_pagevalue_id",                     null: false
    t.integer  "page_num",                              null: false
    t.integer  "instance_pagevalue_id",                 null: false
    t.boolean  "del_flg",               default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instance_pagevalues", force: true do |t|
    t.text     "data"
    t.integer  "retain",     default: 1,     null: false
    t.boolean  "del_flg",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_categories", force: true do |t|
    t.integer  "item_id",     null: false
    t.integer  "category_id", null: false
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
    t.integer  "common_action_event_id", null: false
    t.integer  "locale_id",              null: false
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

  create_table "setting_pagevalues", force: true do |t|
    t.text     "data"
    t.boolean  "del_flg",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_auths", force: true do |t|
    t.string   "name",           null: false
    t.integer  "strength_order", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_pagevalues", force: true do |t|
    t.integer  "user_id",                              null: false
    t.integer  "setting_pagevalue_id"
    t.boolean  "del_flg",              default: false, null: false
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
