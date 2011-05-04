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

ActiveRecord::Schema.define(:version => 10) do

  create_table "addons", :force => true do |t|
    t.integer   "room_id",                   :default => 0,     :null => false
    t.integer   "user_id",                   :default => 0,     :null => false
    t.string    "name",                      :default => "",    :null => false
    t.float     "price",        :limit => 5, :default => 0.0,   :null => false
    t.boolean   "onetime",                   :default => false, :null => false
    t.boolean   "force_cart",                :default => false, :null => false
    t.boolean   "per_person",                :default => false, :null => false
    t.timestamp "created_at",                                   :null => false
    t.timestamp "updated_at",                                   :null => false
    t.integer   "count"
    t.integer   "lock_version",              :default => 0
  end

  create_table "addons_contracts", :id => false, :force => true do |t|
    t.integer "contract_id", :default => 0, :null => false
    t.integer "addon_id",    :default => 0, :null => false
  end

  create_table "admins", :force => true do |t|
  end

  create_table "contracts", :force => true do |t|
    t.float     "total",          :limit => 6,   :default => 0.0, :null => false
    t.date      "arrival",                                        :null => false
    t.date      "departure",                                      :null => false
    t.integer   "adults",                        :default => 0,   :null => false
    t.integer   "children",                      :default => 0,   :null => false
    t.string    "cc_number",      :limit => 100, :default => "",  :null => false
    t.string    "cc_expire_date", :limit => 20,  :default => "",  :null => false
    t.string    "cc_cvv",         :limit => 10,  :default => "",  :null => false
    t.integer   "room_id",                       :default => 0,   :null => false
    t.integer   "customer_id",                   :default => 0,   :null => false
    t.integer   "user_id",                       :default => 0,   :null => false
    t.integer   "pending",        :limit => 2,   :default => 0,   :null => false
    t.integer   "unconfirmed",    :limit => 2,   :default => 0,   :null => false
    t.timestamp "created_at",                                     :null => false
    t.timestamp "updated_at",                                     :null => false
    t.integer   "count"
    t.integer   "lock_version",                  :default => 0
  end

  create_table "customers", :force => true do |t|
    t.string    "name",         :limit => 200, :default => "", :null => false
    t.string    "street",       :limit => 200, :default => "", :null => false
    t.string    "city",         :limit => 100, :default => "", :null => false
    t.string    "zip",          :limit => 50,  :default => "", :null => false
    t.string    "country",      :limit => 200, :default => "", :null => false
    t.string    "telefone",     :limit => 100, :default => "", :null => false
    t.string    "fax",          :limit => 100, :default => "", :null => false
    t.string    "email",        :limit => 100, :default => "", :null => false
    t.integer   "user_id",                     :default => 0,  :null => false
    t.timestamp "created_at",                                  :null => false
    t.timestamp "updated_at",                                  :null => false
    t.integer   "count"
    t.integer   "lock_version",                :default => 0
  end

  create_table "documents", :force => true do |t|
    t.integer   "user_id",                     :default => 0,  :null => false
    t.string    "name",         :limit => 200, :default => "", :null => false
    t.text      "rhtml",                                       :null => false
    t.timestamp "created_at",                                  :null => false
    t.timestamp "updated_at",                                  :null => false
    t.integer   "count"
    t.integer   "lock_version",                :default => 0
  end

  create_table "documents_rooms", :id => false, :force => true do |t|
    t.integer "document_id", :default => 0, :null => false
    t.integer "room_id",     :default => 0, :null => false
  end

  create_table "globalize_countries", :force => true do |t|
    t.string "code",                   :limit => 2
    t.string "english_name"
    t.string "date_format"
    t.string "currency_format"
    t.string "currency_code",          :limit => 3
    t.string "thousands_sep",          :limit => 2
    t.string "decimal_sep",            :limit => 2
    t.string "currency_decimal_sep",   :limit => 2
    t.string "number_grouping_scheme"
  end

  add_index "globalize_countries", ["code"], :name => "globalize_countries_code_index"

  create_table "globalize_languages", :force => true do |t|
    t.string  "iso_639_1",             :limit => 2
    t.string  "iso_639_2",             :limit => 3
    t.string  "iso_639_3",             :limit => 3
    t.string  "rfc_3066"
    t.string  "english_name"
    t.string  "english_name_locale"
    t.string  "english_name_modifier"
    t.string  "native_name"
    t.string  "native_name_locale"
    t.string  "native_name_modifier"
    t.boolean "macro_language"
    t.string  "direction"
    t.string  "pluralization"
    t.string  "scope",                 :limit => 1
  end

  add_index "globalize_languages", ["iso_639_1"], :name => "globalize_languages_iso_639_1_index"
  add_index "globalize_languages", ["iso_639_2"], :name => "globalize_languages_iso_639_2_index"
  add_index "globalize_languages", ["iso_639_3"], :name => "globalize_languages_iso_639_3_index"
  add_index "globalize_languages", ["rfc_3066"], :name => "globalize_languages_rfc_3066_index"

  create_table "globalize_translations", :force => true do |t|
    t.string  "type"
    t.string  "tr_key"
    t.string  "table_name"
    t.integer "item_id"
    t.string  "facet"
    t.integer "language_id"
    t.integer "pluralization_index"
    t.text    "text"
  end

  add_index "globalize_translations", ["table_name", "item_id", "language_id"], :name => "globalize_translations_table_name_index"
  add_index "globalize_translations", ["tr_key", "language_id"], :name => "globalize_translations_tr_key_index"

  create_table "notes", :force => true do |t|
    t.text    "note",                        :null => false
    t.integer "customer_id",  :default => 0, :null => false
    t.integer "user_id",      :default => 0, :null => false
    t.integer "count"
    t.integer "lock_version", :default => 0
  end

  create_table "prices", :force => true do |t|
    t.text      "price",                       :null => false
    t.integer   "adults",       :default => 0, :null => false
    t.integer   "children",     :default => 0, :null => false
    t.integer   "room_id",      :default => 0, :null => false
    t.integer   "user_id",      :default => 0, :null => false
    t.timestamp "created_at",                  :null => false
    t.timestamp "updated_at",                  :null => false
    t.integer   "count"
    t.integer   "lock_version", :default => 0
  end

  create_table "properties", :force => true do |t|
    t.string    "name",         :limit => 200, :default => "", :null => false
    t.string    "city",                        :default => "", :null => false
    t.string    "country",                     :default => "", :null => false
    t.integer   "user_id",                     :default => 0,  :null => false
    t.timestamp "created_at",                                  :null => false
    t.timestamp "updated_at",                                  :null => false
    t.integer   "count"
    t.integer   "lock_version",                :default => 0
  end

  create_table "publics", :force => true do |t|
  end

  create_table "rights", :force => true do |t|
    t.integer "count"
    t.integer "lock_version", :default => 0
  end

  create_table "roles", :force => true do |t|
  end

  create_table "rooms", :force => true do |t|
    t.string    "name",         :limit => 200, :default => "", :null => false
    t.text      "days_of_week",                                :null => false
    t.text      "minimum_stay",                                :null => false
    t.integer   "property_id",                 :default => 0,  :null => false
    t.integer   "user_id",                     :default => 0,  :null => false
    t.timestamp "created_at",                                  :null => false
    t.timestamp "updated_at",                                  :null => false
    t.integer   "count"
    t.integer   "lock_version",                :default => 0
  end

  add_index "rooms", ["property_id"], :name => "fk_property_rooms"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "user_admins", :force => true do |t|
  end

  create_table "users", :force => true do |t|
    t.string    "name",                     :limit => 100, :default => "",       :null => false
    t.string    "hashed_password",          :limit => 40
    t.integer   "admin",                                   :default => 0,        :null => false
    t.string    "homepage",                                :default => "",       :null => false
    t.string    "email",                                   :default => "",       :null => false
    t.string    "datestring",               :limit => 20,  :default => "",       :null => false
    t.string    "currency",                 :limit => 100, :default => "",       :null => false
    t.string    "language",                 :limit => 10,  :default => "",       :null => false
    t.boolean   "creditcard",                              :default => false,    :null => false
    t.text      "header",                                                        :null => false
    t.text      "footer",                                                        :null => false
    t.integer   "confirmed",                :limit => 2,   :default => 0,        :null => false
    t.integer   "premium",                  :limit => 2,   :default => 0,        :null => false
    t.text      "calendar_symbols",                                              :null => false
    t.timestamp "created_at",                                                    :null => false
    t.timestamp "updated_at",                                                    :null => false
    t.string    "calendar_color_arrival",                  :default => "08F7FF"
    t.string    "calendar_color_departure",                :default => "172EFF"
    t.string    "calendar_color_free",                     :default => "05FF05"
    t.string    "calendar_color_blocked",                  :default => "473E34"
    t.integer   "count"
    t.integer   "lock_version",                            :default => 0
  end

  add_index "users", ["name"], :name => "name", :unique => true

end
