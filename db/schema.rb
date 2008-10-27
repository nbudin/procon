# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 40) do

  create_table "attendances", :force => true do |t|
    t.integer  "event_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "counts",      :default => true
    t.boolean  "is_staff"
    t.boolean  "is_waitlist", :default => false
    t.datetime "deleted_at"
  end

  add_index "attendances", ["event_id"], :name => "index_attendances_on_event_id"
  add_index "attendances", ["person_id"], :name => "index_attendances_on_person_id"
  add_index "attendances", ["deleted_at"], :name => "index_attendances_on_deleted_at"

  create_table "attendee_slots", :force => true do |t|
    t.integer  "event_id",   :null => false
    t.integer  "max"
    t.integer  "min"
    t.integer  "preferred"
    t.string   "gender"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attendee_slots", ["event_id"], :name => "index_attendee_slots_on_event_id"

  create_table "event_locations", :force => true do |t|
    t.integer "event_id"
    t.integer "location_id"
    t.boolean "exclusive",   :default => true
  end

  create_table "events", :force => true do |t|
    t.string   "fullname",                                                  :null => false
    t.string   "shortname"
    t.string   "number"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "blurb",                  :limit => 4000
    t.string   "description",            :limit => 4000
    t.integer  "parent_id"
    t.integer  "registration_policy_id"
    t.boolean  "attendees_visible",                      :default => false
  end

  create_table "events_schedule_blocks", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "schedule_block_id"
  end

  create_table "events_tracks", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "track_id"
  end

  create_table "locations", :force => true do |t|
    t.string  "name",      :null => false
    t.integer "parent_id"
  end

  create_table "permissions", :force => true do |t|
    t.integer "role_id"
    t.string  "permission"
    t.integer "permissioned_id"
    t.string  "permissioned_type"
    t.integer "person_id"
  end

  create_table "procon_profiles", :force => true do |t|
    t.integer "person_id"
    t.string  "nickname"
    t.string  "phone"
    t.string  "best_call_time"
  end

  create_table "registration_buckets", :force => true do |t|
    t.integer "event_id",  :null => false
    t.integer "position",  :null => false
    t.integer "max"
    t.integer "min"
    t.integer "preferred"
  end

  create_table "registration_policies", :force => true do |t|
    t.string "name"
    t.date   "created_at", :null => false
    t.date   "updated_at", :null => false
  end

  create_table "registration_rules", :force => true do |t|
    t.string  "type",       :null => false
    t.date    "created_at", :null => false
    t.date    "updated_at", :null => false
    t.integer "policy_id"
    t.integer "bucket_id"
    t.integer "position",   :null => false
    t.string  "gender"
    t.integer "age_min"
    t.integer "age_max"
    t.integer "min_age"
  end

  create_table "schedule_blocks", :force => true do |t|
    t.integer  "schedule_id"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "interval"
  end

  create_table "schedule_blocks_tracks", :id => false, :force => true do |t|
    t.integer "track_id"
    t.integer "schedule_block_id"
  end

  create_table "scheduled_event_positions", :force => true do |t|
    t.integer  "schedule_block_id"
    t.integer  "event_id"
    t.float    "left"
    t.float    "top"
    t.float    "width"
    t.float    "height"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
  end

  create_table "site_templates", :force => true do |t|
    t.string "name",   :null => false
    t.text   "css"
    t.text   "header"
    t.text   "footer"
  end

  create_table "tracks", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.integer  "schedule_id", :null => false
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "virtual_sites", :force => true do |t|
    t.integer "event_id",         :null => false
    t.string  "domain",           :null => false
    t.integer "site_template_id"
  end

  add_index "virtual_sites", ["domain"], :name => "index_virtual_sites_on_domain"
  add_index "virtual_sites", ["event_id"], :name => "index_virtual_sites_on_event_id"

end