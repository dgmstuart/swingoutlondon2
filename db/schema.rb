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

ActiveRecord::Schema.define(version: 20151224130117) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dance_classes", force: :cascade do |t|
    t.integer  "day",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "venue_id",   null: false
  end

  create_table "event_instances", force: :cascade do |t|
    t.date     "date",                                      null: false
    t.integer  "event_seed_id",                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url",           limit: 255
    t.integer  "venue_id"
    t.boolean  "cancelled",                 default: false
  end

  create_table "event_periods", force: :cascade do |t|
    t.integer  "event_seed_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "frequency",     null: false
    t.date     "start_date",    null: false
    t.date     "end_date"
  end

  create_table "event_seeds", force: :cascade do |t|
    t.string   "url",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id",               null: false
    t.integer  "venue_id",               null: false
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       limit: 255, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "venues", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.text     "address",                null: false
    t.string   "postcode",   limit: 255, null: false
    t.string   "url",        limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
