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

ActiveRecord::Schema.define(version: 20161110004610) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text     "comment"
    t.integer  "user_id"
    t.integer  "story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "votes_count", default: 0
  end

  create_table "contests", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "start"
    t.datetime "end"
    t.integer  "user_id"
    t.integer  "prompt_id",   default: 0
    t.boolean  "active",      default: true
    t.boolean  "delta",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", force: :cascade do |t|
    t.string   "from"
    t.string   "to"
    t.integer  "last_send_attempt", default: 0
    t.text     "mail"
    t.datetime "created_on"
  end

  create_table "followings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "writer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prompts", force: :cascade do |t|
    t.string   "hero"
    t.string   "villain"
    t.string   "goal"
    t.date     "use_on"
    t.integer  "rating",            default: 0
    t.integer  "counter",           default: 0
    t.integer  "user_id"
    t.integer  "contest_id",        default: 0
    t.boolean  "active",            default: true
    t.boolean  "verified",          default: true
    t.boolean  "delta",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stories_count",     default: 0
    t.string   "refcode"
    t.string   "kind"
    t.string   "attribution"
    t.string   "attribution_url"
    t.string   "license"
    t.integer  "votes_count",       default: 0
    t.string   "license_url"
    t.string   "license_en"
    t.string   "license_image_url"
    t.text     "start_line"
  end

  create_table "rpx_identifiers", force: :cascade do |t|
    t.string   "identifier",    null: false
    t.string   "provider_name"
    t.integer  "user_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["identifier"], name: "index_rpx_identifiers_on_identifier", unique: true, using: :btree
    t.index ["user_id"], name: "index_rpx_identifiers_on_user_id", using: :btree
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "slugs", force: :cascade do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                  default: 1, null: false
    t.string   "sluggable_type", limit: 40
    t.string   "scope",          limit: 40
    t.datetime "created_at"
    t.index ["name", "sluggable_type", "scope", "sequence"], name: "index_slugs_on_n_s_s_and_s", unique: true, using: :btree
    t.index ["sluggable_id"], name: "index_slugs_on_sluggable_id", using: :btree
  end

  create_table "stories", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "license"
    t.integer  "votes_count",     default: 0
    t.integer  "comment_counter", default: 0
    t.integer  "flagged",         default: 0
    t.integer  "counter",         default: 0
    t.integer  "user_id"
    t.integer  "prompt_id"
    t.integer  "contest_id",      default: 0
    t.boolean  "delta",           default: false
    t.boolean  "active",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
    t.integer  "comments_count",  default: 0
    t.boolean  "featured",        default: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string   "login"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "website"
    t.string   "email_address"
    t.text     "profile"
    t.boolean  "active",               default: true
    t.integer  "admin_level",          default: 1
    t.string   "persistence_token"
    t.integer  "login_count"
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "send_comments",        default: true
    t.boolean  "send_stories",         default: true
    t.boolean  "send_followings",      default: true
    t.string   "name"
    t.integer  "facebook_uid"
    t.string   "facebook_session_key"
    t.integer  "comments_count",       default: 0
    t.integer  "stories_count",        default: 0
    t.boolean  "featured",             default: false
    t.integer  "reputation",           default: 0
  end

  create_table "votes", force: :cascade do |t|
    t.boolean  "vote",          default: false
    t.integer  "voteable_id",                   null: false
    t.string   "voteable_type",                 null: false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["voteable_id", "voteable_type"], name: "fk_voteables", using: :btree
    t.index ["voter_id", "voter_type"], name: "fk_voters", using: :btree
  end

end
