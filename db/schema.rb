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

ActiveRecord::Schema.define(:version => 20110720122600) do

  create_table "clubs", :force => true do |t|
    t.string   "name"
    t.string   "full_name"
    t.string   "internal_name"
    t.string   "description"
    t.string   "url"
    t.string   "registration_method"
    t.boolean  "uses_isic"
    t.text     "isic_text"
    t.text     "confirmation_text"
    t.string   "api_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "ugent_nr"
    t.string   "sex"
    t.string   "phone"
    t.date     "date_of_birth"
    t.string   "home_address"
    t.string   "studenthome_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
