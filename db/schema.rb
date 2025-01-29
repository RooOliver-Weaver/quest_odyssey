# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_01_29_131621) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "campaign_characters", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "campaign_id", null: false
    t.integer "hit_points", null: false
    t.integer "death_saves"
    t.jsonb "inventory"
    t.jsonb "stats"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_campaign_characters_on_campaign_id"
    t.index ["character_id"], name: "index_campaign_characters_on_character_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "name"
    t.string "setting"
    t.text "description"
    t.date "next_session"
    t.bigint "user_id", null: false
    t.text "notes"
    t.boolean "active", default: false
    t.text "dm_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_campaigns_on_user_id"
  end

  create_table "character_sessions", force: :cascade do |t|
    t.bigint "campaign_character_id", null: false
    t.bigint "session_id", null: false
    t.boolean "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_character_id"], name: "index_character_sessions_on_campaign_character_id"
    t.index ["session_id"], name: "index_character_sessions_on_session_id"
  end

  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.string "race"
    t.string "speciality"
    t.integer "level"
    t.jsonb "stats", default: {}
    t.text "biography"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "background"
    t.string "alignment"
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.boolean "approved", default: false
    t.string "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname"
    t.string "availability", default: [], array: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "campaign_characters", "campaigns"
  add_foreign_key "campaign_characters", "characters"
  add_foreign_key "campaigns", "users"
  add_foreign_key "character_sessions", "campaign_characters"
  add_foreign_key "character_sessions", "sessions"
  add_foreign_key "characters", "users"
end
