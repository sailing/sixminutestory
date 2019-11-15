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

ActiveRecord::Schema.define(version: 2019_11_15_153324) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", id: :serial, force: :cascade do |t|
    t.text "comment"
    t.integer "user_id"
    t.integer "story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "votes_count", default: 0
  end

  create_table "contests", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.text "description"
    t.datetime "start"
    t.datetime "end"
    t.integer "user_id"
    t.integer "prompt_id", default: 0
    t.boolean "active", default: true
    t.boolean "delta", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", id: :serial, force: :cascade do |t|
    t.string "from", limit: 255
    t.string "to", limit: 255
    t.integer "last_send_attempt", default: 0
    t.text "mail"
    t.datetime "created_on"
  end

  create_table "followings", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "writer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prompts", id: :serial, force: :cascade do |t|
    t.string "hero", limit: 255
    t.string "villain", limit: 255
    t.string "goal", limit: 255
    t.date "use_on"
    t.integer "rating", default: 0
    t.integer "counter", default: 0
    t.integer "user_id"
    t.integer "contest_id", default: 0
    t.boolean "active", default: true
    t.boolean "verified", default: true
    t.boolean "delta", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "stories_count", default: 0
    t.string "refcode", limit: 255
    t.string "kind", limit: 255
    t.string "attribution", limit: 255
    t.string "attribution_url", limit: 255
    t.string "license", limit: 255
    t.integer "votes_count", default: 0
    t.string "license_url", limit: 255
    t.string "license_en", limit: 255
    t.string "license_image_url", limit: 255
  end

  create_table "rpx_identifiers", id: :serial, force: :cascade do |t|
    t.string "identifier", limit: 255, null: false
    t.string "provider_name", limit: 255
    t.integer "user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["identifier"], name: "index_rpx_identifiers_on_identifier", unique: true
    t.index ["user_id"], name: "index_rpx_identifiers_on_user_id"
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", limit: 255, null: false
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "slugs", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "sluggable_id"
    t.integer "sequence", default: 1, null: false
    t.string "sluggable_type", limit: 40
    t.string "scope", limit: 40
    t.datetime "created_at"
    t.index ["name", "sluggable_type", "scope", "sequence"], name: "index_slugs_on_n_s_s_and_s", unique: true
    t.index ["sluggable_id"], name: "index_slugs_on_sluggable_id"
  end

  create_table "stories", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.text "description"
    t.string "license", limit: 255
    t.integer "votes_count", default: 0
    t.integer "comment_counter", default: 0
    t.integer "flagged", default: 0
    t.integer "counter", default: 0
    t.integer "user_id"
    t.integer "prompt_id"
    t.integer "contest_id", default: 0
    t.boolean "delta", default: false
    t.boolean "active", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "cached_slug", limit: 255
    t.integer "comments_count", default: 0
    t.boolean "featured", default: false
    t.string "ancestry"
    t.integer "ancestry_depth", default: 0
    t.index ["ancestry"], name: "index_stories_on_ancestry"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.integer "tagger_id"
    t.string "tagger_type", limit: 255
    t.string "taggable_type", limit: 255
    t.string "context", limit: 255
    t.datetime "created_at"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "login", limit: 255
    t.string "encrypted_password", limit: 255
    t.string "password_salt", limit: 255
    t.string "website", limit: 255
    t.string "email", limit: 255
    t.text "profile"
    t.boolean "active", default: true
    t.integer "admin_level", default: 1
    t.integer "sign_in_count"
    t.datetime "last_sign_in_at"
    t.datetime "current_sign_in_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "send_comments", default: true
    t.boolean "send_stories", default: true
    t.boolean "send_followings", default: true
    t.string "name", limit: 255
    t.bigint "facebook_uid"
    t.string "facebook_session_key", limit: 255
    t.integer "comments_count", default: 0
    t.integer "stories_count", default: 0
    t.boolean "featured", default: false
    t.integer "reputation", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", id: :serial, force: :cascade do |t|
    t.boolean "vote", default: false
    t.integer "voteable_id", null: false
    t.string "voteable_type", limit: 255, null: false
    t.integer "voter_id"
    t.string "voter_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["voteable_id", "voteable_type"], name: "fk_voteables"
    t.index ["voter_id", "voter_type"], name: "fk_voters"
  end

end
