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

ActiveRecord::Schema.define(version: 20151209141157) do

  create_table "categories", force: true do |t|
    t.string   "category_name", null: false
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "common_actions", force: true do |t|
    t.string   "title",      null: false
    t.string   "dist_token", null: false
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
    t.string   "access_token",                         null: false
    t.string   "title",                                null: false
    t.text     "caption"
    t.string   "thumbnail_img"
    t.string   "thumbnail_url"
    t.integer  "thumbnail_img_width"
    t.integer  "thumbnail_img_height"
    t.integer  "screen_width"
    t.integer  "screen_height"
    t.integer  "page_max",             default: 1
    t.boolean  "show_guide",           default: true
    t.boolean  "show_page_num",        default: false
    t.boolean  "show_chapter_num",     default: false
    t.integer  "created_user_id",                      null: false
    t.integer  "version",              default: 1
    t.boolean  "del_flg",              default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "galleries", ["access_token"], name: "index_galleries_on_access_token", unique: true, using: :btree
  add_index "galleries", ["created_user_id"], name: "index_galleries_on_created_user_id", using: :btree

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

  create_table "item_images", force: true do |t|
    t.integer  "user_project_map_id",                 null: false
    t.integer  "gallery_id"
    t.string   "item_obj_id",                         null: false
    t.string   "event_dist_id"
    t.string   "file_path"
    t.text     "link_url"
    t.boolean  "del_flg",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_images", ["gallery_id", "item_obj_id"], name: "item_images_index2", using: :btree
  add_index "item_images", ["user_project_map_id"], name: "item_images_index1", using: :btree

  create_table "locales", force: true do |t|
    t.string   "i18n_locale", null: false
    t.string   "locale_name", null: false
    t.integer  "order",       null: false
    t.string   "domain"
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
    t.string   "dist_token",     null: false
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
    t.string   "title",      limit: 100,                 null: false
    t.boolean  "is_sample",              default: false
    t.boolean  "del_flg",                default: false
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
    t.string   "access_token",                           null: false
    t.string   "name",                                   null: false
    t.string   "uid"
    t.integer  "user_auth_id",           default: 4,     null: false
    t.string   "email",                                  null: false
    t.string   "encrypted_password",                     null: false
    t.boolean  "guest",                  default: false
    t.string   "provider"
    t.string   "thumbnail_img"
    t.string   "thumbnail_url"
    t.string   "provider_token"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "del_flg",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["access_token"], name: "index_users_on_access_token", unique: true, using: :btree

end
