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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130427214800) do

  create_table "git_projects", :primary_key => "project_id", :force => true do |t|
  end

  create_table "git_repos", :primary_key => "repo_id", :force => true do |t|
    t.integer "owner_id"
    t.integer "project_id", :null => false
    t.integer "origin_id"
  end

  create_table "projects", :force => true do |t|
    t.string   "subtype",                        :null => false
    t.string   "name",                           :null => false
    t.string   "uid",                            :null => false
    t.string   "description"
    t.boolean  "private",     :default => false, :null => false
    t.integer  "owner_id",                       :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "projects", ["name"], :name => "index_projects_on_name", :unique => true
  add_index "projects", ["uid"], :name => "index_projects_on_uid", :unique => true

  create_table "repos", :force => true do |t|
    t.string   "uuid",         :null => false
    t.string   "subtype",      :null => false
    t.string   "virtual_path", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "repos", ["uuid"], :name => "index_repos_on_uuid", :unique => true

  create_table "ssh_keys", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "fingerprint", :null => false
    t.string   "key_type",    :null => false
    t.string   "base64",      :null => false
    t.string   "comment",     :null => false
    t.integer  "size",        :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "ssh_keys", ["user_id"], :name => "index_ssh_keys_on_user_id"

  create_table "svn_projects", :primary_key => "project_id", :force => true do |t|
  end

  create_table "svn_repos", :primary_key => "repo_id", :force => true do |t|
    t.integer "project_id", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "uid",                            :null => false
    t.string   "common_name",                    :null => false
    t.string   "surname",                        :null => false
    t.string   "password"
    t.string   "email",                          :null => false
    t.boolean  "admin",       :default => false, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["uid"], :name => "index_users_on_uid", :unique => true

end
