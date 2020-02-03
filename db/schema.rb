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

ActiveRecord::Schema.define(version: 2020_02_03_114318) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.text "address"
    t.float "longitude"
    t.float "latitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "worktime"
    t.index ["organization_id"], name: "index_addresses_on_organization_id"
  end

  create_table "articles", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "url"
    t.datetime "from_at"
    t.string "provider"
  end

  create_table "blocks", force: :cascade do |t|
    t.text "content"
    t.string "type"
    t.integer "position"
    t.bigint "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_blocks_on_page_id"
  end

  create_table "bugs", id: :serial, force: :cascade do |t|
    t.text "content"
    t.text "url"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.string "categorable_type"
    t.integer "categorable_id"
    t.text "desc"
    t.string "ancestry"
    t.text "url"
    t.boolean "check", default: false
    t.integer "organizations_count", default: 0, null: false
    t.index ["ancestry"], name: "index_categories_on_ancestry"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
    t.index ["title"], name: "index_categories_on_title", unique: true
  end

  create_table "categories_organizations", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "organization_id"
    t.index ["category_id"], name: "index_categories_organizations_on_category_id"
    t.index ["organization_id"], name: "index_categories_organizations_on_organization_id"
  end

  create_table "ckeditor_assets", id: :serial, force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "width"
    t.integer "height"
    t.string "data_fingerprint"
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.string "commentable_type"
    t.integer "commentable_id"
    t.integer "state"
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hidden", default: true, null: false
    t.index ["ancestry"], name: "index_comments_on_ancestry"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "user_id"
    t.string "url"
    t.string "src_file_name"
    t.string "src_content_type"
    t.bigint "src_file_size"
    t.datetime "src_updated_at"
    t.time "eventime"
    t.date "eventdate"
    t.boolean "hidden", default: true
    t.boolean "cool", default: false
    t.integer "cached_votes_total", default: 0
    t.integer "cached_votes_up", default: 0
    t.integer "cached_votes_down", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.boolean "gmaps"
    t.time "finishtime"
    t.date "finishdate"
    t.boolean "timeless", default: false
    t.text "siteurl"
    t.string "placename"
    t.string "old_title"
    t.boolean "excluded_flag", default: false
    t.integer "views", default: 0, null: false
    t.index ["cached_votes_down"], name: "index_events_on_cached_votes_down"
    t.index ["cached_votes_total"], name: "index_events_on_cached_votes_total"
    t.index ["cached_votes_up"], name: "index_events_on_cached_votes_up"
    t.index ["cool"], name: "index_events_on_cool"
    t.index ["hidden"], name: "index_events_on_hidden"
    t.index ["siteurl"], name: "index_events_on_siteurl"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "follows", id: :serial, force: :cascade do |t|
    t.string "follower_type"
    t.integer "follower_id"
    t.string "followable_type"
    t.integer "followable_id"
    t.datetime "created_at"
    t.index ["followable_id", "followable_type"], name: "fk_followables"
    t.index ["follower_id", "follower_type"], name: "fk_follows"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 40
    t.datetime "created_at"
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "letters", id: :serial, force: :cascade do |t|
    t.text "content", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", id: :serial, force: :cascade do |t|
    t.string "liker_type"
    t.integer "liker_id"
    t.string "likeable_type"
    t.integer "likeable_id"
    t.datetime "created_at"
    t.index ["likeable_id", "likeable_type"], name: "fk_likeables"
    t.index ["liker_id", "liker_type"], name: "fk_likes"
  end

  create_table "mentions", id: :serial, force: :cascade do |t|
    t.string "mentioner_type"
    t.integer "mentioner_id"
    t.string "mentionable_type"
    t.integer "mentionable_id"
    t.datetime "created_at"
    t.index ["mentionable_id", "mentionable_type"], name: "fk_mentionables"
    t.index ["mentioner_id", "mentioner_type"], name: "fk_mentions"
  end

  create_table "notes", id: :serial, force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "email"
  end

  create_table "organizations", id: :serial, force: :cascade do |t|
    t.text "title", null: false
    t.text "old_title", null: false
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.bigint "logo_file_size"
    t.datetime "logo_updated_at"
    t.text "desc"
    t.float "longitude"
    t.float "latitude"
    t.text "address"
    t.string "site"
    t.text "worktime"
    t.text "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "postal_code"
    t.string "address_region"
    t.string "address_locality"
    t.text "street_address"
    t.text "office"
    t.text "url"
    t.integer "views", default: 0, null: false
    t.string "email"
    t.integer "user_id"
    t.boolean "notify", default: false
    t.integer "status_mask", default: 1, null: false
    t.string "token"
    t.boolean "hidden", default: true, null: false
    t.index ["user_id"], name: "index_organizations_on_user_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_pages_on_slug", unique: true
  end

  create_table "photos", id: :serial, force: :cascade do |t|
    t.string "slide_file_name"
    t.string "slide_content_type"
    t.bigint "slide_file_size"
    t.datetime "slide_updated_at"
    t.integer "place_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year"
    t.text "content"
    t.string "author"
    t.index ["place_id"], name: "index_photos_on_place_id"
    t.index ["user_id"], name: "index_photos_on_user_id"
  end

  create_table "places", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cached_votes_total", default: 0
    t.integer "cached_votes_score", default: 0
    t.integer "cached_votes_up", default: 0
    t.integer "cached_votes_down", default: 0
    t.integer "cached_weighted_score", default: 0
    t.integer "cached_weighted_total", default: 0
    t.float "cached_weighted_average", default: 0.0
    t.text "address"
    t.float "longitude"
    t.float "latitude"
    t.index ["user_id"], name: "index_places_on_user_id"
  end

  create_table "profiles", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.text "aboutme"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.bigint "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "gender", limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "login", null: false
    t.string "slug"
    t.integer "roles_mask", default: 8
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "password_salt"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "provider"
    t.integer "uid"
    t.text "auth_raw_info"
    t.string "invitation_token"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login"], name: "index_users_on_login", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "videos", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "url"
    t.integer "likers_count", default: 0
    t.integer "views", default: 0
    t.integer "comments_count", default: 0
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_videos_on_user_id"
  end

  create_table "votes", id: :serial, force: :cascade do |t|
    t.string "votable_type"
    t.integer "votable_id"
    t.string "voter_type"
    t.integer "voter_id"
    t.boolean "vote_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["votable_id", "votable_type"], name: "index_votes_on_votable_id_and_votable_type"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
    t.index ["voter_id", "voter_type"], name: "index_votes_on_voter_id_and_voter_type"
  end

  add_foreign_key "addresses", "organizations"
  add_foreign_key "blocks", "pages"
  add_foreign_key "comments", "users"
  add_foreign_key "organizations", "users"
  add_foreign_key "photos", "places"
  add_foreign_key "photos", "users"
  add_foreign_key "places", "users"
  add_foreign_key "videos", "users"
end
