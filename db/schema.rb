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

ActiveRecord::Schema.define(version: 20170207131448) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bjond_registrations", force: :cascade do |t|
    t.string   "server"
    t.string   "encrypted_encryption_key"
    t.string   "encrypted_encryption_key_iv"
    t.string   "host"
    t.string   "ip"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "bjond_services", force: :cascade do |t|
    t.string   "group_id"
    t.string   "endpoint"
    t.string   "bjond_registration_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "bjond_validic_user_conversions", force: :cascade do |t|
    t.string   "validic_id"
    t.string   "bjond_id"
    t.string   "user_access_token"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "validic_configurations", force: :cascade do |t|
    t.string   "api_key"
    t.string   "secret"
    t.string   "bjond_registration_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "sample_person_id"
  end

end
