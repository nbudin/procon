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

ActiveRecord::Schema.define(:version => 20120106154754) do

  create_table "attached_images", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_created_at"
    t.datetime "image_updated_at"
    t.integer  "site_template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attendances", :force => true do |t|
    t.integer  "event_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "counts",            :default => true
    t.boolean  "is_staff"
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
    t.integer  "event_id",                  :null => false
    t.integer  "max",        :default => 0, :null => false
    t.integer  "min",        :default => 0, :null => false
    t.integer  "preferred",  :default => 0, :null => false
    t.string   "gender"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attendee_slots", ["event_id"], :name => "index_attendee_slots_on_event_id"

  create_table "auth_tickets", :force => true do |t|
    t.string   "secret",     :limit => 40
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "expires_at"
  end

  add_index "auth_tickets", ["secret"], :name => "secret", :unique => true

  create_table "event_locations", :force => true do |t|
    t.integer "event_id"
    t.integer "location_id"
    t.boolean "exclusive",   :default => true
  end

  create_table "events", :force => true do |t|
    t.string   "fullname",                                                       :null => false
    t.string   "shortname"
    t.string   "number"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "blurb",                       :limit => 4000
    t.string   "description",                 :limit => 4000
    t.integer  "parent_id"
    t.integer  "registration_policy_id"
    t.boolean  "attendees_visible",                           :default => false
    t.text     "proposed_timing"
    t.text     "proposal_comments"
    t.text     "proposed_location"
    t.text     "proposed_capacity_limits"
    t.integer  "proposer_id"
    t.integer  "proposed_event_id"
    t.integer  "max_child_event_attendances"
    t.boolean  "counts_for_max_attendances",                  :default => true,  :null => false
  end

  add_index "events", ["proposed_event_id"], :name => "index_events_on_proposed_event_id"

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

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "permission_caches", :force => true do |t|
    t.integer "person_id"
    t.integer "permissioned_id"
    t.string  "permissioned_type"
    t.string  "permission_name"
    t.boolean "result"
  end

  add_index "permission_caches", ["permission_name"], :name => "index_permission_caches_on_permission_name"
  add_index "permission_caches", ["permissioned_id", "permissioned_type"], :name => "index_permission_caches_on_permissioned"
  add_index "permission_caches", ["person_id"], :name => "index_permission_caches_on_person_id"

  create_table "permissions", :force => true do |t|
    t.integer "role_id"
    t.string  "permission"
    t.integer "permissioned_id"
    t.string  "permissioned_type"
    t.integer "person_id"
  end

  create_table "plugin_schema_info", :id => false, :force => true do |t|
    t.string  "plugin_name"
    t.integer "version"
  end

  create_table "procon_profiles", :force => true do |t|
    t.integer "person_id"
    t.string  "nickname"
    t.string  "phone"
    t.string  "best_call_time"
  end

  create_table "public_info_fields", :force => true do |t|
    t.string   "name"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "public_info_fields", ["event_id"], :name => "index_public_info_fields_on_event_id"

  create_table "public_info_values", :force => true do |t|
    t.integer  "public_info_field_id"
    t.integer  "attendance_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.boolean  "published"
  end

  create_table "site_templates", :force => true do |t|
    t.string "name",            :null => false
    t.text   "css"
    t.text   "header"
    t.text   "footer"
    t.text   "themeroller_css"
  end

  create_table "staff_positions", :force => true do |t|
    t.integer  "event_id"
    t.string   "name"
    t.boolean  "publish_email", :default => true
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer "event_id"
    t.string  "domain",           :null => false
    t.integer "site_template_id"
    t.string  "name"
  end

  add_index "virtual_sites", ["domain"], :name => "index_virtual_sites_on_domain"
  add_index "virtual_sites", ["event_id"], :name => "index_virtual_sites_on_event_id"

end
