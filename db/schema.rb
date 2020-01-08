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

ActiveRecord::Schema.define(version: 20200106133402) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "finish_schedule_time"
    t.text "business_process"
    t.boolean "tomorrow"
    t.string "confirmation"
    t.string "approval", default: "申請中"
    t.boolean "change_checkbox"
    t.string "approval_attendance"
    t.string "confirmation_attendance"
    t.datetime "after_started_at"
    t.datetime "after_finished_at"
    t.string "after_note"
    t.string "zokucho_approval"
    t.string "zokucho_confirmation"
    t.date "zokucho_day"
    t.boolean "zokucho_box"
    t.datetime "log_started_at"
    t.datetime "log_finished_at"
    t.string "log_approval"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "log_after_started_at"
    t.datetime "log_after_finished_at"
    t.string "log_confirmation"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bases", force: :cascade do |t|
    t.integer "base_number"
    t.string "base_name"
    t.string "base_kind"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bases_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "affiliation"
    t.datetime "basic_work_time", default: "2020-01-08 23:00:00"
    t.datetime "work_time", default: "2020-01-08 22:30:00"
    t.datetime "designated_work_start_time", default: "2020-01-09 00:00:00"
    t.datetime "designated_work_end_time", default: "2019-12-01 08:00:00"
    t.integer "employee_number"
    t.string "uid"
    t.boolean "superior", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
