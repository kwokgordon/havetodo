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

ActiveRecord::Schema.define(version: 20140425211458) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendships", force: true do |t|
    t.integer "user_id",   null: false
    t.integer "friend_id", null: false
    t.string  "status",    null: false
  end

  add_index "friendships", ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id", unique: true, using: :btree

  create_table "task_comments", force: true do |t|
    t.integer  "task_id",    null: false
    t.integer  "user_id",    null: false
    t.string   "user_name",  null: false
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasklists", force: true do |t|
    t.string   "name"
    t.string   "color",      default: "#000000", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasklists_tasks", id: false, force: true do |t|
    t.integer "task_id",     null: false
    t.integer "tasklist_id", null: false
  end

  add_index "tasklists_tasks", ["task_id", "tasklist_id"], name: "index_tasklists_tasks_on_task_id_and_tasklist_id", unique: true, using: :btree

  create_table "tasklists_users", id: false, force: true do |t|
    t.integer "user_id",     null: false
    t.integer "tasklist_id", null: false
  end

  add_index "tasklists_users", ["user_id", "tasklist_id"], name: "index_tasklists_users_on_user_id_and_tasklist_id", unique: true, using: :btree

  create_table "tasks", force: true do |t|
    t.string   "name"
    t.text     "note"
    t.integer  "priority",            default: 0,     null: false
    t.date     "due_date"
    t.time     "due_time"
    t.boolean  "completed",           default: false, null: false
    t.datetime "completed_date"
    t.integer  "completed_user_id"
    t.string   "completed_user_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks_users", id: false, force: true do |t|
    t.integer "user_id", null: false
    t.integer "task_id", null: false
  end

  add_index "tasks_users", ["user_id", "task_id"], name: "index_tasks_users_on_user_id_and_task_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                   default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
