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

ActiveRecord::Schema.define(:version => 20130918141506) do

  create_table "cards", :force => true do |t|
    t.integer  "member_id"
    t.integer  "academic_year"
    t.integer  "number"
    t.string   "status",        :default => "unpaid"
    t.boolean  "enabled",       :default => true
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "isic_status",   :default => "none"
    t.string   "isic_number"
    t.boolean  "isic_exported", :default => false
  end

  add_index "cards", ["academic_year", "number"], :name => "index_cards_on_academic_year_and_number", :unique => true
  add_index "cards", ["member_id"], :name => "index_cards_on_member_id"

  create_table "clubs", :force => true do |t|
    t.string   "name"
    t.string   "full_name"
    t.string   "internal_name"
    t.string   "description"
    t.string   "url"
    t.string   "registration_method", :default => "none"
    t.boolean  "uses_isic",           :default => false
    t.text     "isic_text"
    t.text     "confirmation_text"
    t.string   "api_key"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "range_lower"
    t.integer  "range_upper"
    t.integer  "isic_mail_option",    :default => 0
    t.string   "isic_name"
  end

  add_index "clubs", ["api_key"], :name => "index_clubs_on_api_key", :unique => true
  add_index "clubs", ["internal_name"], :name => "index_clubs_on_internal_name", :unique => true

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "queue"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "extra_attribute_specs", :force => true do |t|
    t.integer  "club_id"
    t.string   "name"
    t.string   "field_type"
    t.text     "values",     :limit => 65535
    t.boolean  "required"
    t.integer  "position"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "extra_attributes", :force => true do |t|
    t.integer  "member_id"
    t.integer  "spec_id"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "isic_exports", :force => true do |t|
    t.string   "status",           :default => "requested"
    t.text     "members"
    t.string   "data_file_name"
    t.string   "photos_file_name"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "club_id"
    t.string   "export_type"
  end

  create_table "members", :force => true do |t|
    t.integer  "club_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "ugent_nr"
    t.string   "sex"
    t.string   "phone"
    t.date     "date_of_birth"
    t.string   "home_address"
    t.string   "studenthome_address"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "isic_newsletter"
    t.boolean  "isic_mail_card"
    t.boolean  "enabled",                 :default => false
    t.integer  "last_registration"
    t.string   "home_street"
    t.string   "home_postal_code"
    t.string   "home_city"
    t.string   "studenthome_street"
    t.string   "studenthome_postal_code"
    t.string   "studenthome_city"
  end

  add_index "members", ["ugent_nr"], :name => "index_members_on_ugent_nr"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

end
