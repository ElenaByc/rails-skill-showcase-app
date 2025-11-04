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

ActiveRecord::Schema[8.0].define(version: 2025_11_04_042801) do
  create_table "certificate_skills", force: :cascade do |t|
    t.integer "certificate_id", null: false
    t.integer "skill_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["certificate_id", "skill_id"], name: "index_certificate_skills_on_certificate_id_and_skill_id", unique: true
    t.index ["certificate_id"], name: "index_certificate_skills_on_certificate_id"
    t.index ["skill_id"], name: "index_certificate_skills_on_skill_id"
  end

  create_table "certificates", force: :cascade do |t|
    t.string "name"
    t.date "issued_on"
    t.string "verification_url"
    t.integer "user_id", null: false
    t.integer "issuer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
    t.index ["issuer_id"], name: "index_certificates_on_issuer_id"
    t.index ["user_id"], name: "index_certificates_on_user_id"
  end

  create_table "issuers", force: :cascade do |t|
    t.string "name"
    t.string "website_url"
    t.string "logo_url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_by", null: false
    t.index ["created_by"], name: "index_issuers_on_created_by"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_by", null: false
    t.index ["created_by"], name: "index_skills_on_created_by"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "certificate_skills", "certificates"
  add_foreign_key "certificate_skills", "skills"
  add_foreign_key "certificates", "issuers"
  add_foreign_key "certificates", "users"
  add_foreign_key "issuers", "users", column: "created_by"
  add_foreign_key "skills", "users", column: "created_by"
end
