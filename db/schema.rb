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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140226121136) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answer_revisions", force: true do |t|
    t.integer  "answer_id",  null: false
    t.integer  "editor_id",  null: false
    t.text     "text",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answer_revisions", ["answer_id"], name: "index_answer_revisions_on_answer_id", using: :btree
  add_index "answer_revisions", ["editor_id"], name: "index_answer_revisions_on_editor_id", using: :btree

  create_table "answers", force: true do |t|
    t.integer  "author_id",                  null: false
    t.integer  "question_id",                null: false
    t.text     "text",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "votes_total",    default: 0, null: false
    t.integer  "comments_count", default: 0, null: false
    t.integer  "votes_count",    default: 0, null: false
  end

  add_index "answers", ["author_id"], name: "index_answers_on_author_id", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["votes_total"], name: "index_answers_on_votes_total", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name",                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tags",               default: [],              array: true
    t.integer  "questions_count",    default: 0,  null: false
    t.string   "slido_username"
    t.string   "slido_event_prefix"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree
  add_index "categories", ["slido_username"], name: "index_categories_on_slido_username", using: :btree

  create_table "comment_revisions", force: true do |t|
    t.integer  "comment_id", null: false
    t.integer  "editor_id",  null: false
    t.text     "text",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comment_revisions", ["comment_id"], name: "index_comment_revisions_on_comment_id", using: :btree
  add_index "comment_revisions", ["editor_id"], name: "index_comment_revisions_on_editor_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "author_id",        null: false
    t.integer  "commentable_id",   null: false
    t.string   "commentable_type", null: false
    t.text     "text",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["author_id"], name: "index_comments_on_author_id", using: :btree
  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree

  create_table "evaluations", force: true do |t|
    t.integer  "evaluator_id",   null: false
    t.integer  "evaluable_id",   null: false
    t.string   "evaluable_type", null: false
    t.text     "text"
    t.integer  "value",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "evaluations", ["evaluable_id", "evaluable_type"], name: "index_evaluations_on_evaluable_id_and_evaluable_type", using: :btree
  add_index "evaluations", ["evaluator_id"], name: "index_evaluations_on_evaluator_id", using: :btree

  create_table "events", force: true do |t|
    t.json     "data",       null: false
    t.datetime "created_at", null: false
  end

  add_index "events", ["created_at"], name: "index_events_on_created_at", using: :btree

  create_table "favorites", force: true do |t|
    t.integer  "favorer_id",  null: false
    t.integer  "question_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["favorer_id", "question_id"], name: "index_favorites_on_unique_key", unique: true, using: :btree
  add_index "favorites", ["favorer_id"], name: "index_favorites_on_favorer_id", using: :btree
  add_index "favorites", ["question_id"], name: "index_favorites_on_question_id", using: :btree

  create_table "followings", force: true do |t|
    t.integer  "follower_id", null: false
    t.integer  "followee_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "followings", ["followee_id"], name: "index_followings_on_followee_id", using: :btree
  add_index "followings", ["follower_id", "followee_id"], name: "index_followings_on_unique_key", unique: true, using: :btree
  add_index "followings", ["follower_id"], name: "index_followings_on_follower_id", using: :btree

  create_table "labelings", force: true do |t|
    t.integer  "author_id",  null: false
    t.integer  "answer_id",  null: false
    t.integer  "label_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "labelings", ["answer_id"], name: "index_labelings_on_answer_id", using: :btree
  add_index "labelings", ["author_id", "answer_id", "label_id"], name: "index_labelings_on_unique_key", unique: true, using: :btree
  add_index "labelings", ["author_id"], name: "index_labelings_on_author_id", using: :btree
  add_index "labelings", ["label_id"], name: "index_labelings_on_label_id", using: :btree

  create_table "labels", force: true do |t|
    t.string   "value",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "labels", ["value"], name: "index_labels_on_value", unique: true, using: :btree

  create_table "question_revisions", force: true do |t|
    t.integer  "question_id", null: false
    t.integer  "editor_id",   null: false
    t.string   "category",    null: false
    t.string   "tags",        null: false, array: true
    t.string   "title",       null: false
    t.text     "text",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_revisions", ["editor_id"], name: "index_question_revisions_on_editor_id", using: :btree
  add_index "question_revisions", ["question_id"], name: "index_question_revisions_on_question_id", using: :btree

  create_table "questions", force: true do |t|
    t.integer  "author_id",                                           null: false
    t.integer  "category_id",                                         null: false
    t.string   "title",                                               null: false
    t.text     "text",                                                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "votes_total",         default: 0,                     null: false
    t.boolean  "anonymous",           default: false,                 null: false
    t.integer  "answers_count",       default: 0,                     null: false
    t.integer  "comments_count",      default: 0,                     null: false
    t.integer  "favorites_count",     default: 0,                     null: false
    t.integer  "views_count",         default: 0,                     null: false
    t.integer  "votes_count",         default: 0,                     null: false
    t.integer  "slido_question_uuid"
    t.integer  "slido_event_uuid"
    t.datetime "touched_at",          default: '2014-02-26 13:18:34', null: false
  end

  add_index "questions", ["author_id"], name: "index_questions_on_author_id", using: :btree
  add_index "questions", ["category_id"], name: "index_questions_on_category_id", using: :btree
  add_index "questions", ["slido_question_uuid"], name: "index_questions_on_slido_question_uuid", unique: true, using: :btree
  add_index "questions", ["title"], name: "index_questions_on_title", using: :btree
  add_index "questions", ["votes_total"], name: "index_questions_on_votes_total", using: :btree

  create_table "slido_events", force: true do |t|
    t.integer  "category_id", null: false
    t.integer  "uuid",        null: false
    t.string   "identifier",  null: false
    t.string   "name",        null: false
    t.string   "url",         null: false
    t.datetime "started_at",  null: false
    t.datetime "ended_at",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "slido_events", ["category_id"], name: "index_slido_events_on_category_id", using: :btree
  add_index "slido_events", ["ended_at"], name: "index_slido_events_on_ended_at", using: :btree
  add_index "slido_events", ["started_at"], name: "index_slido_events_on_started_at", using: :btree
  add_index "slido_events", ["uuid"], name: "index_slido_events_on_uuid", unique: true, using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id",        null: false
    t.integer  "taggable_id",   null: false
    t.string   "taggable_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type"], name: "index_taggings_on_tag_id_and_taggable_id_and_taggable_type", using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type"], name: "index_taggings_on_taggable_id_and_taggable_type", using: :btree

  create_table "tags", force: true do |t|
    t.string "name", null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "login",                                      null: false
    t.string   "email",                  default: "",        null: false
    t.string   "encrypted_password",     default: "",        null: false
    t.string   "ais_uid"
    t.string   "ais_login"
    t.string   "nick",                                       null: false
    t.string   "name"
    t.string   "first"
    t.string   "middle"
    t.string   "last"
    t.text     "about"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "linkedin"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,         null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.string   "current_sign_in_ip"
    t.datetime "last_sign_in_at"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gravatar_email"
    t.boolean  "show_name",              default: true,      null: false
    t.boolean  "show_email",             default: true,      null: false
    t.string   "bitbucket"
    t.string   "flickr"
    t.string   "foursquare"
    t.string   "github"
    t.string   "google_plus"
    t.string   "instagram"
    t.string   "pinterest"
    t.string   "stack_overflow"
    t.string   "tumblr"
    t.string   "youtube"
    t.string   "role",                   default: "student", null: false
    t.integer  "answers_count",          default: 0,         null: false
    t.integer  "comments_count",         default: 0,         null: false
    t.integer  "favorites_count",        default: 0,         null: false
    t.integer  "questions_count",        default: 0,         null: false
    t.integer  "views_count",            default: 0,         null: false
    t.integer  "votes_count",            default: 0,         null: false
  end

  add_index "users", ["ais_login"], name: "index_users_on_ais_login", unique: true, using: :btree
  add_index "users", ["ais_uid"], name: "index_users_on_ais_uid", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["first"], name: "index_users_on_first", using: :btree
  add_index "users", ["last"], name: "index_users_on_last", using: :btree
  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree
  add_index "users", ["middle"], name: "index_users_on_middle", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["nick"], name: "index_users_on_nick", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role"], name: "index_users_on_role", using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "views", force: true do |t|
    t.integer  "question_id", null: false
    t.integer  "viewer_id",   null: false
    t.datetime "created_at"
  end

  add_index "views", ["question_id"], name: "index_views_on_question_id", using: :btree
  add_index "views", ["viewer_id"], name: "index_views_on_viewer_id", using: :btree

  create_table "votes", force: true do |t|
    t.integer  "voter_id",                    null: false
    t.integer  "votable_id",                  null: false
    t.string   "votable_type",                null: false
    t.boolean  "upvote",       default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["upvote"], name: "index_votes_on_upvote", using: :btree
  add_index "votes", ["votable_id", "votable_type", "upvote"], name: "index_votes_on_votable_id_and_votable_type_and_upvote", using: :btree
  add_index "votes", ["voter_id", "votable_id", "votable_type"], name: "index_votes_on_unique_key", unique: true, using: :btree
  add_index "votes", ["voter_id"], name: "index_votes_on_voter_id", using: :btree

  create_table "watchings", force: true do |t|
    t.integer  "watcher_id",     null: false
    t.integer  "watchable_id",   null: false
    t.string   "watchable_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "watchings", ["watchable_id", "watchable_type"], name: "index_watchings_on_watchable_id_and_watchable_type", using: :btree
  add_index "watchings", ["watcher_id", "watchable_id", "watchable_type"], name: "index_watchings_on_unique_key", unique: true, using: :btree
  add_index "watchings", ["watcher_id"], name: "index_watchings_on_watcher_id", using: :btree

end
