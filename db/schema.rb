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

ActiveRecord::Schema.define(version: 20130828234830) do

  create_table "branches", force: true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commits", force: true do |t|
    t.integer  "deployment_id"
    t.string   "sha"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "configurations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deploy_options", force: true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.string   "value"
    t.boolean  "visible",    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deployments", force: true do |t|
    t.integer  "branch_id"
    t.integer  "environment_id"
    t.string   "revision"
    t.string   "log_file"
    t.boolean  "success"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer  "created_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "environments", force: true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.string   "git_repo_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
