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

ActiveRecord::Schema[8.0].define(version: 2025_10_19_084321) do
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

  create_table "bands", force: :cascade do |t|
    t.string "band_name"
    t.string "genre"
    t.string "band_bandcamp_link"
    t.string "band_instagram_link"
    t.string "band_description"
    t.string "band_location"
    t.string "band_email"
    t.string "band_ffo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "local"
    t.boolean "pending", default: true
    t.boolean "approved"
  end

  create_table "bands_genres", id: false, force: :cascade do |t|
    t.integer "band_id", null: false
    t.integer "genre_id", null: false
    t.index ["band_id"], name: "index_bands_genres_on_band_id"
    t.index ["genre_id"], name: "index_bands_genres_on_genre_id"
  end

  create_table "bands_posts", id: false, force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "band_id", null: false
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres_posts", id: false, force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "genre_id", null: false
    t.index ["genre_id"], name: "index_genres_posts_on_genre_id"
    t.index ["post_id"], name: "index_genres_posts_on_post_id"
  end

  create_table "installs", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_installs_on_email", unique: true
    t.index ["reset_password_token"], name: "index_installs_on_reset_password_token", unique: true
  end

  create_table "invitations", force: :cascade do |t|
    t.string "email"
    t.string "token"
    t.boolean "used"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "bands"
    t.string "time"
    t.string "event_date"
    t.string "membership_required"
    t.string "suggested_donation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visibility"
    t.string "event_name"
    t.string "google_calendar_event_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bands_genres", "bands"
  add_foreign_key "bands_genres", "genres"
  add_foreign_key "genres_posts", "genres"
  add_foreign_key "genres_posts", "posts"
end
