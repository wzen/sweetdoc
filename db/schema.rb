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

ActiveRecord::Schema.define(version: 20141229141229) do

  create_table "action_events", force: true do |t|
    t.integer  "item_type"
    t.string   "mothod_name"
    t.integer  "event_type_id"
    t.integer  "locale_id"
    t.text     "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_css_temps", force: true do |t|
    t.integer  "item_type",  null: false
    t.text     "contents"
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

  create_table "locales", force: true do |t|
    t.integer  "locale_id"
    t.string   "locale_name"
    t.integer  "order"
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

end
