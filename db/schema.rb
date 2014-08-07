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

ActiveRecord::Schema.define(version: 20140807214614) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "event_generators", force: true do |t|
    t.integer  "event_seed_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "frequency",     null: false
    t.date     "start_date",    null: false
  end

  create_table "event_instances", force: true do |t|
    t.date     "date",       null: false
    t.integer  "event_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
  end

  create_table "event_seeds", force: true do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id",   null: false
  end

  create_table "events", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
