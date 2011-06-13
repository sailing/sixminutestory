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

ActiveRecord::Schema.define(:version => 20110613085127) do

  create_table "comments", :force => true do |t|
    t.text      "comment"
    t.integer   "user_id"
    t.integer   "story_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "votes_count", :default => 0
  end

  create_table "contests", :force => true do |t|
    t.string    "title"
    t.text      "description"
    t.timestamp "start"
    t.timestamp "end"
    t.integer   "user_id"
    t.integer   "prompt_id",   :default => 0
    t.boolean   "active",      :default => true
    t.boolean   "delta",       :default => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "emails", :force => true do |t|
    t.string    "from"
    t.string    "to"
    t.integer   "last_send_attempt", :default => 0
    t.text      "mail"
    t.timestamp "created_on"
  end

  create_table "favorites_users", :force => true do |t|
    t.integer  "favorite_id"
    t.string   "favorite_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "followings", :force => true do |t|
    t.integer   "user_id"
    t.integer   "writer_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "prompts", :force => true do |t|
    t.string    "hero"
    t.string    "villain"
    t.string    "goal"
    t.date      "use_on"
    t.integer   "rating",          :default => 0
    t.integer   "counter",         :default => 0
    t.integer   "user_id"
    t.integer   "contest_id",      :default => 0
    t.boolean   "active",          :default => true
    t.boolean   "verified",        :default => true
    t.boolean   "delta",           :default => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "stories_count",   :default => 0
    t.string    "refcode"
    t.string    "kind"
    t.string    "attribution"
    t.string    "attribution_url"
    t.string    "license"
    t.integer   "votes_count",     :default => 0
  end

  create_table "rpx_identifiers", :force => true do |t|
    t.string    "identifier",    :null => false
    t.string    "provider_name"
    t.integer   "user_id",       :null => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "rpx_identifiers", ["identifier"], :name => "index_rpx_identifiers_on_identifier", :unique => true
  add_index "rpx_identifiers", ["user_id"], :name => "index_rpx_identifiers_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string    "session_id", :null => false
    t.text      "data"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "slugs", :force => true do |t|
    t.string    "name"
    t.integer   "sluggable_id"
    t.integer   "sequence",                     :default => 1, :null => false
    t.string    "sluggable_type", :limit => 40
    t.string    "scope",          :limit => 40
    t.timestamp "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "scope", "sequence"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "stories", :force => true do |t|
    t.string    "title"
    t.text      "description"
    t.string    "license"
    t.integer   "votes_count",     :default => 0
    t.integer   "comment_counter", :default => 0
    t.integer   "flagged",         :default => 0
    t.integer   "counter",         :default => 0
    t.integer   "user_id"
    t.integer   "prompt_id"
    t.integer   "contest_id",      :default => 0
    t.boolean   "delta",           :default => false
    t.boolean   "active",          :default => true
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "cached_slug"
    t.integer   "comments_count",  :default => 0
    t.boolean   "featured",        :default => false
  end

  create_table "taggings", :force => true do |t|
    t.integer   "tag_id"
    t.integer   "taggable_id"
    t.integer   "tagger_id"
    t.string    "tagger_type"
    t.string    "taggable_type"
    t.string    "context"
    t.timestamp "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "website"
    t.string   "email_address"
    t.text     "profile"
    t.boolean  "active",               :default => true
    t.integer  "admin_level",          :default => 1
    t.string   "persistence_token"
    t.integer  "login_count"
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "send_comments",        :default => true
    t.boolean  "send_stories",         :default => true
    t.boolean  "send_followings",      :default => true
    t.string   "name"
    t.integer  "facebook_uid"
    t.string   "facebook_session_key"
    t.integer  "comments_count",       :default => 0
    t.integer  "stories_count",        :default => 0
    t.boolean  "featured",             :default => false
    t.integer  "reputation",           :default => 0
  end

  create_table "votes", :force => true do |t|
    t.boolean   "vote",          :default => false
    t.integer   "voteable_id",                      :null => false
    t.string    "voteable_type",                    :null => false
    t.integer   "voter_id"
    t.string    "voter_type"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "fk_voteables"
  add_index "votes", ["voter_id", "voter_type"], :name => "fk_voters"

end
