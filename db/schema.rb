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

ActiveRecord::Schema.define(version: 20180906032813) do

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name"
    t.integer "subcategory", limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exercises", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "category_id"
    t.string "name"
    t.string "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "routines", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "user_id"
    t.integer "stage_id"
    t.integer "exercise_id"
    t.integer "set"
    t.integer "rep"
    t.integer "seconds_down"
    t.integer "seconds_hold"
    t.integer "seconds_up"
    t.integer "porcentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stage_configurations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "stage_id"
    t.integer "day"
    t.integer "category_id"
    t.integer "subcategory_id"
    t.integer "exercise_id"
    t.integer "set"
    t.integer "rep"
    t.integer "seconds_down", default: 0, unsigned: true
    t.integer "seconds_hold", default: 0, unsigned: true
    t.integer "seconds_up", default: 0, unsigned: true
    t.integer "porcentage", default: 0, unsigned: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name"
    t.string "acronym", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subcategories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "category_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_informations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "user_id"
    t.integer "user_type_id"
    t.text "first_name"
    t.text "last_name"
    t.date "birth_date"
    t.integer "genre"
    t.string "height"
    t.string "weight"
    t.integer "sport"
    t.integer "position"
    t.string "next_competition"
    t.integer "experience"
    t.text "history_injuries"
    t.date "pay_day"
    t.integer "pay_program"
    t.text "goal_1"
    t.text "goal_2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.text "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
