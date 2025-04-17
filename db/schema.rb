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

ActiveRecord::Schema[8.0].define(version: 2025_04_17_122809) do
  create_table "events", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.text "description"
    t.datetime "start_date", null: false
    t.datetime "end_date"
    t.string "location", limit: 100
    t.bigint "creator_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "frequency", default: 0, null: false
    t.index ["creator_id"], name: "index_events_on_creator_id"
    t.index ["group_id"], name: "index_events_on_group_id"
    t.index ["name"], name: "index_events_on_name"
    t.index ["start_date"], name: "index_events_on_start_date"
    t.check_constraint "`end_date` is null or `end_date` > `start_date`", name: "check_end_after_start"
  end

  create_table "group_memberships", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "joined_at", default: -> { "current_timestamp(6)" }
    t.index ["group_id"], name: "fk_rails_d05778f88b"
    t.index ["user_id", "group_id"], name: "index_group_memberships_on_user_id_and_group_id", unique: true
  end

  create_table "groups", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "visibility", null: false
    t.bigint "owner_id", null: false
    t.string "join_code", default: "123", null: false
    t.index ["owner_id"], name: "fk_rails_d62517ff60"
    t.index ["visibility"], name: "index_groups_on_visibility"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "email", limit: 50, default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username", limit: 28, null: false
    t.date "date_of_birth", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "user", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "events", "groups"
  add_foreign_key "events", "users", column: "creator_id"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "groups", "users", column: "owner_id"
end
