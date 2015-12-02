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

ActiveRecord::Schema.define(version: 20151202022806) do

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
    t.integer  "action_type_id",                     null: false
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
    t.boolean  "del_flg",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_pagevalues", force: true do |t|
    t.text     "data"
    t.boolean  "del_flg",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "galleries", force: true do |t|
    t.string   "access_token",                                                 null: false
    t.string   "title",                                                        null: false
    t.text     "caption"
    t.binary   "thumbnail_img",               limit: 16777215,                 null: false
    t.string   "thumbnail_img_contents_type",                                  null: false
    t.integer  "thumbnail_img_width",                                          null: false
    t.integer  "thumbnail_img_height",                                         null: false
    t.integer  "screen_width",                                                 null: false
    t.integer  "screen_height",                                                null: false
    t.integer  "page_max",                                     default: 1
    t.boolean  "show_guide",                                   default: true
    t.boolean  "show_page_num",                                default: false
    t.boolean  "show_chapter_num",                             default: false
    t.integer  "version",                                      default: 1
    t.boolean  "del_flg",                                      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "galleries", ["access_token"], name: "index_galleries_on_access_token", unique: true, using: :btree

  create_table "gallery_bookmark_statistics", force: true do |t|
    t.integer  "gallery_id",                 null: false
    t.integer  "count",      default: 0
    t.date     "view_day"
    t.boolean  "del_flg",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gallery_bookmarks", force: true do |t|
    t.integer  "user_id",                    null: false
    t.integer  "gallery_id",                 null: false
    t.text     "note"
    t.boolean  "del_flg",    default: false
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
    t.text     "data"
    t.boolean  "del_flg",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gallery_general_pagevalue_pagings", force: true do |t|
    t.integer  "gallery_id",                                   null: false
    t.integer  "page_num",                                     null: false
    t.integer  "gallery_general_pagevalue_id",                 null: false
    t.boolean  "del_flg",                      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gallery_general_pagevalues", force: true do |t|
    t.text     "data"
    t.boolean  "del_flg",    default: false
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
    t.text     "data"
    t.boolean  "del_flg",    default: false
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
    t.integer  "weight",     default: 0
    t.string   "category"
    t.boolean  "del_flg",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gallery_view_statistics", force: true do |t|
    t.integer  "gallery_id",                 null: false
    t.integer  "count",      default: 0
    t.date     "view_day"
    t.boolean  "del_flg",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "general_common_pagevalues", force: true do |t|
    t.integer  "user_pagevalue_id",                 null: false
    t.text     "data"
    t.boolean  "del_flg",           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "general_pagevalue_pagings", force: true do |t|
    t.integer  "user_pagevalue_id",                    null: false
    t.integer  "page_num",                             null: false
    t.integer  "general_pagevalue_id",                 null: false
    t.boolean  "del_flg",              default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "general_pagevalues", force: true do |t|
    t.text     "data"
    t.boolean  "del_flg",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instance_pagevalue_pagings", force: true do |t|
    t.integer  "user_pagevalue_id",                     null: false
    t.integer  "page_num",                              null: false
    t.integer  "instance_pagevalue_id",                 null: false
    t.boolean  "del_flg",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instance_pagevalues", force: true do |t|
    t.text     "data"
    t.boolean  "del_flg",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_categories", force: true do |t|
    t.integer  "item_id",     null: false
    t.integer  "category_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_galleries", force: true do |t|
    t.string   "access_token",                    null: false
    t.integer  "created_user_id",                 null: false
    t.string   "title",                           null: false
    t.text     "caption"
    t.string   "class_name",                      null: false
    t.integer  "public_type",                     null: false
    t.string   "file_name",                       null: false
    t.integer  "version",         default: 1
    t.boolean  "del_flg",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_gallery_tag_maps", force: true do |t|
    t.integer  "item_gallery_id",                     null: false
    t.integer  "item_gallery_tag_id",                 null: false
    t.boolean  "del_flg",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_gallery_tags", force: true do |t|
    t.string   "name",                       null: false
    t.integer  "weight",     default: 0
    t.string   "category"
    t.boolean  "del_flg",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_gallery_using_statistics", force: true do |t|
    t.integer  "item_gallery_id",                 null: false
    t.integer  "count",           default: 0
    t.boolean  "del_flg",         default: false
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

  create_table "preload_items", force: true do |t|
    t.string   "title",          null: false
    t.text     "caption"
    t.string   "class_name",     null: false
    t.string   "file_name",      null: false
    t.integer  "create_user_id", null: false
    t.integer  "modify_user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_gallery_maps", force: true do |t|
    t.integer  "user_project_map_id",                 null: false
    t.integer  "gallery_id",                          null: false
    t.boolean  "del_flg",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_gallery_maps", ["user_project_map_id", "gallery_id"], name: "index_project_gallery_maps_on_user_project_map_id_and_gallery_id", unique: true, using: :btree

  create_table "projects", force: true do |t|
    t.string   "title"
    t.integer  "screen_width",                  null: false
    t.integer  "screen_height",                 null: false
    t.boolean  "del_flg",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "setting_pagevalues", force: true do |t|
    t.boolean  "autosave",                                 null: false
    t.float    "autosave_time", limit: 24
    t.boolean  "grid_enable",                              null: false
    t.integer  "grid_step"
    t.boolean  "del_flg",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_auths", force: true do |t|
    t.string   "name",           null: false
    t.integer  "strength_order", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_coding_trees", force: true do |t|
    t.integer  "user_id",                        null: false
    t.text     "node_path",                      null: false
    t.string   "user_coding_id"
    t.boolean  "del_flg",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_coding_trees", ["user_id"], name: "index_user_coding_trees_on_user_id", using: :btree

  create_table "user_codings", force: true do |t|
    t.integer  "user_id",                       null: false
    t.string   "lang_type",                     null: false
    t.integer  "draw_type",                     null: false
    t.string   "code_filename",                 null: false
    t.boolean  "del_flg",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_gallery_footprint_pagevalues", force: true do |t|
    t.text     "data"
    t.boolean  "del_flg",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_gallery_footprint_pagings", force: true do |t|
    t.integer  "user_id",                                             null: false
    t.integer  "gallery_id",                                          null: false
    t.integer  "page_num",                                            null: false
    t.integer  "user_gallery_footprint_pagevalue_id",                 null: false
    t.boolean  "del_flg",                             default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_gallery_footprint_pagings", ["user_id", "gallery_id", "page_num"], name: "user_gallery_footprint_pagings_index", unique: true, using: :btree

  create_table "user_gallery_footprints", force: true do |t|
    t.integer  "user_id"
    t.integer  "gallery_id"
    t.integer  "page_num"
    t.boolean  "del_flg",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_gallery_footprints", ["user_id", "gallery_id"], name: "user_gallery_footprints_index", unique: true, using: :btree

  create_table "user_item_gallery_maps", force: true do |t|
    t.integer  "user_id",                         null: false
    t.integer  "item_gallery_id",                 null: false
    t.boolean  "del_flg",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_item_gallery_maps", ["user_id", "item_gallery_id"], name: "index_user_item_gallery_maps_on_user_id_and_item_gallery_id", unique: true, using: :btree

  create_table "user_pagevalues", force: true do |t|
    t.integer  "user_project_map_id",                  null: false
    t.integer  "setting_pagevalue_id"
    t.boolean  "del_flg",              default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_project_maps", force: true do |t|
    t.integer  "user_id",                    null: false
    t.integer  "project_id",                 null: false
    t.boolean  "del_flg",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_project_maps", ["user_id", "project_id"], name: "index_user_project_maps_on_user_id_and_project_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "access_token",                                            null: false
    t.string   "name",                                                    null: false
    t.string   "uid"
    t.integer  "user_auth_id",                            default: 3,     null: false
    t.string   "email",                                                   null: false
    t.string   "encrypted_password",                                      null: false
    t.boolean  "guest",                                   default: false
    t.string   "provider"
    t.binary   "thumbnail_img",          limit: 16777215
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                           default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "del_flg",                                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["access_token"], name: "index_users_on_access_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
