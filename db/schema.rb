# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080924180353) do

  create_table "dat_projects", :force => true do |t|
    t.string   "project_cd",                    :null => false
    t.string   "project_name",                  :null => false
    t.date     "start_date"
    t.date     "delivery_date"
    t.integer  "valid_flg",      :default => 1, :null => false
    t.integer  "create_user_id",                :null => false
    t.datetime "created_on",                    :null => false
    t.integer  "update_user_id",                :null => false
    t.datetime "updated_on",                    :null => false
    t.string   "end_user_name"
  end

  create_table "dat_projectusers", :force => true do |t|
    t.integer  "project_id",                                  :null => false
    t.string   "email",          :limit => 40,                :null => false
    t.integer  "user_id"
    t.integer  "create_user_id",                              :null => false
    t.datetime "created_on",                                  :null => false
    t.integer  "active_flg",                   :default => 1
  end

  create_table "mst_users", :force => true do |t|
    t.string   "login_id"
    t.string   "password",                                                :null => false
    t.string   "user_name",                                               :null => false
    t.string   "email",                                                   :null => false
    t.string   "name"
    t.integer  "sex"
    t.date     "birthday"
    t.string   "company_name",              :limit => 60
    t.string   "section_name",              :limit => 60
    t.string   "zip",                       :limit => 8
    t.string   "prefecture",                :limit => 10
    t.string   "address1",                  :limit => 100
    t.string   "address2",                  :limit => 100
    t.string   "tel",                       :limit => 14
    t.string   "fax",                       :limit => 14
    t.date     "start_date"
    t.date     "expire_date"
    t.integer  "valid_flg",                                :default => 1, :null => false
    t.integer  "create_user_id"
    t.datetime "created_on",                                              :null => false
    t.integer  "update_user_id"
    t.datetime "updated_on",                                              :null => false
    t.string   "srcpassword"
    t.string   "skype_id"
    t.datetime "last_login_on"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

  create_table "projects", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
