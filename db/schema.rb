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

ActiveRecord::Schema.define(:version => 20110111142848) do

  create_table "attached_images", :force => true do |t|
    t.string    "image_file_name"
    t.string    "image_content_type"
    t.integer   "image_file_size"
    t.timestamp "image_created_at"
    t.timestamp "image_updated_at"
    t.integer   "site_template_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "attendances", :force => true do |t|
    t.integer  "event_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "counts",            :default => true
    t.boolean  "is_waitlist",       :default => false
    t.datetime "deleted_at"
    t.string   "gender"
    t.integer  "staff_position_id"
  end

  add_index "attendances", ["counts"], :name => "index_attendances_on_counts"
  add_index "attendances", ["deleted_at"], :name => "index_attendances_on_deleted_at"
  add_index "attendances", ["event_id"], :name => "index_attendances_on_event_id"
  add_index "attendances", ["gender"], :name => "index_attendances_on_gender"
  add_index "attendances", ["person_id"], :name => "index_attendances_on_person_id"

  create_table "attendee_slots", :force => true do |t|
    t.integer   "event_id",                  :null => false
    t.integer   "max",        :default => 0, :null => false
    t.integer   "min",        :default => 0, :null => false
    t.integer   "preferred",  :default => 0, :null => false
    t.string    "gender"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "attendee_slots", ["event_id"], :name => "index_attendee_slots_on_event_id"

  create_table "event_locations", :force => true do |t|
    t.integer "event_id"
    t.integer "location_id"
    t.boolean "exclusive",   :default => true
  end

  create_table "events", :force => true do |t|
    t.string   "fullname",                                                    :null => false
    t.string   "shortname"
    t.string   "number"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "blurb",                    :limit => 4000
    t.string   "description",              :limit => 4000
    t.integer  "registration_policy_id"
    t.boolean  "attendees_visible",                        :default => false
    t.text     "proposed_timing"
    t.text     "proposal_comments"
    t.text     "proposed_location"
    t.text     "proposed_capacity_limits"
    t.integer  "proposer_id"
    t.integer  "proposed_event_id"
    t.string   "ancestry"
  end

  add_index "events", ["ancestry"], :name => "index_events_on_ancestry"
  add_index "events", ["proposed_event_id"], :name => "index_events_on_proposed_event_id"

  create_table "events_tracks", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "track_id"
  end

  create_table "locations", :force => true do |t|
    t.string "name",     :null => false
    t.string "ancestry"
  end

  add_index "locations", ["ancestry"], :name => "index_locations_on_ancestry"

  create_table "people", :force => true do |t|
    t.string   "email"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "gender"
    t.datetime "birthdate"
    t.string   "nickname"
    t.string   "phone"
    t.string   "best_call_time"
    t.boolean  "admin"
    t.string   "username"
    t.integer  "sign_in_count",      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "people", ["username"], :name => "index_people_on_username", :unique => true

  create_table "plugin_schema_info", :id => false, :force => true do |t|
    t.string  "plugin_name"
    t.integer "version"
  end

  create_table "proposed_events", :force => true do |t|
    t.string   "fullname",                                                    :null => false
    t.string   "shortname"
    t.string   "blurb",                    :limit => 4000
    t.string   "description",              :limit => 4000
    t.integer  "registration_policy_id"
    t.integer  "proposer_id"
    t.integer  "parent_id"
    t.boolean  "attendees_visible",                        :default => false
    t.text     "proposed_timing"
    t.text     "proposal_comments"
    t.text     "proposed_location"
    t.text     "proposed_capacity_limits"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "public_info_fields", :force => true do |t|
    t.string    "name"
    t.integer   "event_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "public_info_fields", ["event_id"], :name => "index_public_info_fields_on_event_id"

  create_table "public_info_values", :force => true do |t|
    t.integer   "public_info_field_id"
    t.integer   "attendance_id"
    t.string    "value"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "public_info_values", ["attendance_id"], :name => "index_public_info_values_on_attendance_id"
  add_index "public_info_values", ["public_info_field_id"], :name => "index_public_info_values_on_public_info_field_id"

  create_table "registration_buckets", :force => true do |t|
    t.integer "event_id",  :null => false
    t.integer "position"
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
    t.integer "position"
    t.string  "gender"
    t.integer "age_min"
    t.integer "age_max"
    t.integer "min_age"
  end

  create_table "schedules", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "event_id"
    t.boolean   "published"
  end

  create_table "site_templates", :force => true do |t|
    t.string "name",            :null => false
    t.text   "css"
    t.text   "header"
    t.text   "footer"
    t.text   "themeroller_css"
  end

  create_table "staffers", :force => true do |t|
    t.integer  "event_id"
    t.integer  "person_id"
    t.string   "title"
    t.boolean  "listed"
    t.integer  "position"
    t.boolean  "publish_email"
    t.boolean  "event_admin"
    t.boolean  "proposal_admin"
    t.boolean  "schedule_admin"
    t.boolean  "attendee_viewer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "staffers", ["event_id"], :name => "index_staffers_on_event_id"

  create_table "tracks", :force => true do |t|
    t.string    "name"
    t.integer   "position"
    t.integer   "schedule_id", :null => false
    t.string    "color"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "virtual_sites", :force => true do |t|
    t.integer "event_id"
    t.string  "domain",           :null => false
    t.integer "site_template_id"
    t.string  "name"
  end

  add_index "virtual_sites", ["domain"], :name => "index_virtual_sites_on_domain"
  add_index "virtual_sites", ["event_id"], :name => "index_virtual_sites_on_event_id"

end
