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

ActiveRecord::Schema[7.0].define(version: 2023_01_04_042413) do
  create_table "authors", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bulbs", force: :cascade do |t|
    t.integer "car_id"
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "frickinawesome", default: false
    t.index ["car_id"], name: "index_bulbs_on_car_id"
  end

  create_table "cars", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.text "type"
    t.integer "client_of"
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "firm_id"
    t.text "firm_name"
    t.index ["firm_id"], name: "index_companies_on_firm_id"
  end

  create_table "essays", force: :cascade do |t|
    t.integer "author_id"
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "writer_id"
    t.text "writer_type"
    t.index ["author_id"], name: "index_essays_on_author_id"
    t.index ["writer_id"], name: "index_essays_on_writer_id"
  end

  create_table "people", force: :cascade do |t|
    t.text "first_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer "author_id", null: false
    t.text "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_posts_on_author_id"
  end

  create_table "subscribers", primary_key: "nick", id: :text, force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.text "subscriber_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id", null: false
    t.string "taggable_type", null: false
    t.integer "taggable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable"
  end

  create_table "tags", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bulbs", "cars"
  add_foreign_key "companies", "companies", column: "firm_id"
  add_foreign_key "essays", "authors"
  add_foreign_key "posts", "authors"
  add_foreign_key "subscriptions", "subscribers", primary_key: "nick"
  add_foreign_key "taggings", "tags"
end
