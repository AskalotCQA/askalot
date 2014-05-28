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

ActiveRecord::Schema.define(version: 20140523061344) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.integer  "initiator_id",                  null: false
    t.integer  "resource_id",                   null: false
    t.string   "resource_type",                 null: false
    t.string   "action",                        null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.date     "created_on",                    null: false
    t.date     "updated_on",                    null: false
    t.boolean  "anonymous",     default: false, null: false
  end

  add_index "activities", ["action"], name: "index_activities_on_action", using: :btree
  add_index "activities", ["anonymous"], name: "index_activities_on_anonymous", using: :btree
  add_index "activities", ["created_at"], name: "index_activities_on_created_at", using: :btree
  add_index "activities", ["created_on"], name: "index_activities_on_created_on", using: :btree
  add_index "activities", ["initiator_id"], name: "index_activities_on_initiator_id", using: :btree
  add_index "activities", ["resource_id", "resource_type"], name: "index_activities_on_resource_id_and_resource_type", using: :btree
  add_index "activities", ["resource_type"], name: "index_activities_on_resource_type", using: :btree

  create_table "answer_revisions", force: true do |t|
    t.integer  "answer_id",                  null: false
    t.integer  "editor_id",                  null: false
    t.text     "text",                       null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "deleted",    default: false, null: false
    t.datetime "deleted_at"
    t.integer  "deletor_id"
  end

  add_index "answer_revisions", ["answer_id"], name: "index_answer_revisions_on_answer_id", using: :btree
  add_index "answer_revisions", ["deleted"], name: "index_answer_revisions_on_deleted", using: :btree
  add_index "answer_revisions", ["deletor_id"], name: "index_answer_revisions_on_deletor_id", using: :btree
  add_index "answer_revisions", ["editor_id"], name: "index_answer_revisions_on_editor_id", using: :btree

  create_table "answers", force: true do |t|
    t.integer  "author_id",                                                   null: false
    t.integer  "question_id",                                                 null: false
    t.text     "text",                                                        null: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.integer  "votes_difference",                            default: 0,     null: false
    t.integer  "comments_count",                              default: 0,     null: false
    t.integer  "votes_count",                                 default: 0,     null: false
    t.boolean  "deleted",                                     default: false, null: false
    t.decimal  "votes_lb_wsci_bp",  precision: 13, scale: 12, default: 0.0,   null: false
    t.datetime "edited_at"
    t.integer  "editor_id"
    t.datetime "deleted_at"
    t.integer  "deletor_id"
    t.boolean  "edited",                                      default: false, null: false
    t.integer  "evaluations_count",                           default: 0,     null: false
    t.integer  "document_id"
  end

  add_index "answers", ["author_id"], name: "index_answers_on_author_id", using: :btree
  add_index "answers", ["deleted"], name: "index_answers_on_deleted", using: :btree
  add_index "answers", ["deletor_id"], name: "index_answers_on_deletor_id", using: :btree
  add_index "answers", ["document_id"], name: "index_answers_on_document_id", using: :btree
  add_index "answers", ["edited"], name: "index_answers_on_edited", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["votes_difference"], name: "index_answers_on_votes_difference", using: :btree
  add_index "answers", ["votes_lb_wsci_bp"], name: "index_answers_on_votes_lb_wsci_bp", using: :btree

  create_table "assignments", force: true do |t|
    t.integer  "user_id",     null: false
    t.integer  "category_id", null: false
    t.integer  "role_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["category_id"], name: "index_assignments_on_category_id", using: :btree
  add_index "assignments", ["role_id"], name: "index_assignments_on_role_id", using: :btree
  add_index "assignments", ["user_id"], name: "index_assignments_on_user_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name",                            null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "tags",               default: [],              array: true
    t.integer  "questions_count",    default: 0,  null: false
    t.string   "slido_username"
    t.string   "slido_event_prefix"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree
  add_index "categories", ["slido_username"], name: "index_categories_on_slido_username", using: :btree

  create_table "changelogs", force: true do |t|
    t.text     "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "title"
    t.string   "version",    null: false
  end

  add_index "changelogs", ["created_at"], name: "index_changelogs_on_created_at", using: :btree
  add_index "changelogs", ["version"], name: "index_changelogs_on_version", unique: true, using: :btree

  create_table "comment_revisions", force: true do |t|
    t.integer  "comment_id",                 null: false
    t.integer  "editor_id",                  null: false
    t.text     "text",                       null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "deleted",    default: false, null: false
    t.datetime "deleted_at"
    t.integer  "deletor_id"
  end

  add_index "comment_revisions", ["comment_id"], name: "index_comment_revisions_on_comment_id", using: :btree
  add_index "comment_revisions", ["deleted"], name: "index_comment_revisions_on_deleted", using: :btree
  add_index "comment_revisions", ["deletor_id"], name: "index_comment_revisions_on_deletor_id", using: :btree
  add_index "comment_revisions", ["editor_id"], name: "index_comment_revisions_on_editor_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "author_id",                        null: false
    t.integer  "commentable_id",                   null: false
    t.string   "commentable_type",                 null: false
    t.text     "text",                             null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "deleted",          default: false, null: false
    t.datetime "edited_at"
    t.integer  "editor_id"
    t.datetime "deleted_at"
    t.integer  "deletor_id"
    t.boolean  "edited",           default: false, null: false
  end

  add_index "comments", ["author_id"], name: "index_comments_on_author_id", using: :btree
  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["deleted"], name: "index_comments_on_deleted", using: :btree
  add_index "comments", ["deletor_id"], name: "index_comments_on_deletor_id", using: :btree
  add_index "comments", ["edited"], name: "index_comments_on_edited", using: :btree

  create_table "documents", force: true do |t|
    t.integer  "group_id",      null: false
    t.string   "title",         null: false
    t.string   "document_type"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["group_id"], name: "index_documents_on_group_id", using: :btree
  add_index "documents", ["title"], name: "index_documents_on_title", using: :btree

  create_table "evaluations", force: true do |t|
    t.integer  "author_id",                      null: false
    t.integer  "evaluable_id",                   null: false
    t.string   "evaluable_type",                 null: false
    t.text     "text"
    t.integer  "value",                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deleted",        default: false, null: false
    t.datetime "deleted_at"
    t.integer  "deletor_id"
  end

  add_index "evaluations", ["author_id"], name: "index_evaluations_on_author_id", using: :btree
  add_index "evaluations", ["deleted"], name: "index_evaluations_on_deleted", using: :btree
  add_index "evaluations", ["deletor_id"], name: "index_evaluations_on_deletor_id", using: :btree
  add_index "evaluations", ["evaluable_id", "evaluable_type"], name: "index_evaluations_on_evaluable_id_and_evaluable_type", using: :btree

  create_table "events", force: true do |t|
    t.json     "data",       null: false
    t.datetime "created_at", null: false
  end

  add_index "events", ["created_at"], name: "index_events_on_created_at", using: :btree

  create_table "favorites", force: true do |t|
    t.integer  "favorer_id",                  null: false
    t.integer  "question_id",                 null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "deleted",     default: false, null: false
    t.datetime "deleted_at"
    t.integer  "deletor_id"
  end

  add_index "favorites", ["deleted"], name: "index_favorites_on_deleted", using: :btree
  add_index "favorites", ["deletor_id"], name: "index_favorites_on_deletor_id", using: :btree
  add_index "favorites", ["favorer_id", "question_id"], name: "index_favorites_on_unique_key", unique: true, using: :btree
  add_index "favorites", ["favorer_id"], name: "index_favorites_on_favorer_id", using: :btree
  add_index "favorites", ["question_id"], name: "index_favorites_on_question_id", using: :btree

  create_table "followings", force: true do |t|
    t.integer  "follower_id",                 null: false
    t.integer  "followee_id",                 null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "deleted",     default: false, null: false
    t.integer  "deletor_id"
    t.datetime "deleted_at"
  end

  add_index "followings", ["deleted"], name: "index_followings_on_deleted", using: :btree
  add_index "followings", ["deletor_id"], name: "index_followings_on_deletor_id", using: :btree
  add_index "followings", ["followee_id"], name: "index_followings_on_followee_id", using: :btree
  add_index "followings", ["follower_id", "followee_id"], name: "index_followings_on_unique_key", unique: true, using: :btree
  add_index "followings", ["follower_id"], name: "index_followings_on_follower_id", using: :btree

  create_table "groups", force: true do |t|
    t.integer  "owner_id",                           null: false
    t.string   "title",           default: "",       null: false
    t.string   "description"
    t.string   "visibility",      default: "public", null: false
    t.boolean  "deleted",         default: false,    null: false
    t.integer  "deletor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "documents_count", default: 0,        null: false
  end

  add_index "groups", ["deletor_id"], name: "index_groups_on_deletor_id", using: :btree
  add_index "groups", ["owner_id"], name: "index_groups_on_owner_id", using: :btree
  add_index "groups", ["title"], name: "index_groups_on_title", using: :btree

  create_table "labelings", force: true do |t|
    t.integer  "author_id",                  null: false
    t.integer  "answer_id",                  null: false
    t.integer  "label_id",                   null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "deleted",    default: false, null: false
    t.datetime "deleted_at"
    t.integer  "deletor_id"
  end

  add_index "labelings", ["answer_id", "label_id", "author_id"], name: "index_labelings_on_unique_key", unique: true, using: :btree
  add_index "labelings", ["answer_id"], name: "index_labelings_on_answer_id", using: :btree
  add_index "labelings", ["author_id"], name: "index_labelings_on_author_id", using: :btree
  add_index "labelings", ["deleted"], name: "index_labelings_on_deleted", using: :btree
  add_index "labelings", ["deletor_id"], name: "index_labelings_on_deletor_id", using: :btree
  add_index "labelings", ["label_id"], name: "index_labelings_on_label_id", using: :btree

  create_table "labels", force: true do |t|
    t.string   "value",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "labels", ["value"], name: "index_labels_on_value", unique: true, using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "recipient_id",                  null: false
    t.integer  "initiator_id",                  null: false
    t.integer  "resource_id",                   null: false
    t.string   "resource_type",                 null: false
    t.string   "action",                        null: false
    t.boolean  "unread",        default: true,  null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.datetime "read_at"
    t.boolean  "anonymous",     default: false, null: false
  end

  add_index "notifications", ["action"], name: "index_notifications_on_action", using: :btree
  add_index "notifications", ["anonymous"], name: "index_notifications_on_anonymous", using: :btree
  add_index "notifications", ["created_at"], name: "index_notifications_on_created_at", using: :btree
  add_index "notifications", ["initiator_id"], name: "index_notifications_on_initiator_id", using: :btree
  add_index "notifications", ["recipient_id"], name: "index_notifications_on_recipient_id", using: :btree
  add_index "notifications", ["resource_id", "resource_type"], name: "index_notifications_on_resource_id_and_resource_type", using: :btree
  add_index "notifications", ["resource_type"], name: "index_notifications_on_resource_type", using: :btree
  add_index "notifications", ["unread"], name: "index_notifications_on_unread", using: :btree

  create_table "question_revisions", force: true do |t|
    t.integer  "question_id",                 null: false
    t.integer  "editor_id",                   null: false
    t.string   "category",                    null: false
    t.string   "tags",                        null: false, array: true
    t.string   "title",                       null: false
    t.text     "text",                        null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "deleted",     default: false, null: false
    t.datetime "deleted_at"
    t.integer  "deletor_id"
  end

  add_index "question_revisions", ["deleted"], name: "index_question_revisions_on_deleted", using: :btree
  add_index "question_revisions", ["deletor_id"], name: "index_question_revisions_on_deletor_id", using: :btree
  add_index "question_revisions", ["editor_id"], name: "index_question_revisions_on_editor_id", using: :btree
  add_index "question_revisions", ["question_id"], name: "index_question_revisions_on_question_id", using: :btree

  create_table "questions", force: true do |t|
    t.integer  "author_id",                                                     null: false
    t.integer  "category_id",                                                   null: false
    t.string   "title",                                                         null: false
    t.text     "text",                                                          null: false
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.integer  "votes_difference",                              default: 0,     null: false
    t.boolean  "anonymous",                                     default: false, null: false
    t.integer  "answers_count",                                 default: 0,     null: false
    t.integer  "comments_count",                                default: 0,     null: false
    t.integer  "favorites_count",                               default: 0,     null: false
    t.integer  "views_count",                                   default: 0,     null: false
    t.integer  "votes_count",                                   default: 0,     null: false
    t.integer  "slido_question_uuid"
    t.integer  "slido_event_uuid"
    t.boolean  "deleted",                                       default: false, null: false
    t.decimal  "votes_lb_wsci_bp",    precision: 13, scale: 12, default: 0.0,   null: false
    t.datetime "touched_at",                                                    null: false
    t.datetime "edited_at"
    t.integer  "editor_id"
    t.datetime "deleted_at"
    t.integer  "deletor_id"
    t.boolean  "edited",                                        default: false, null: false
    t.integer  "evaluations_count",                             default: 0,     null: false
    t.integer  "document_id"
  end

  add_index "questions", ["anonymous"], name: "index_questions_on_anonymous", using: :btree
  add_index "questions", ["author_id"], name: "index_questions_on_author_id", using: :btree
  add_index "questions", ["category_id"], name: "index_questions_on_category_id", using: :btree
  add_index "questions", ["deleted"], name: "index_questions_on_deleted", using: :btree
  add_index "questions", ["deletor_id"], name: "index_questions_on_deletor_id", using: :btree
  add_index "questions", ["document_id"], name: "index_questions_on_document_id", using: :btree
  add_index "questions", ["edited"], name: "index_questions_on_edited", using: :btree
  add_index "questions", ["slido_question_uuid"], name: "index_questions_on_slido_question_uuid", unique: true, using: :btree
  add_index "questions", ["title"], name: "index_questions_on_title", using: :btree
  add_index "questions", ["touched_at"], name: "index_questions_on_touched_at", using: :btree
  add_index "questions", ["votes_difference"], name: "index_questions_on_votes_difference", using: :btree
  add_index "questions", ["votes_lb_wsci_bp"], name: "index_questions_on_votes_lb_wsci_bp", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "slido_events", force: true do |t|
    t.integer  "category_id", null: false
    t.integer  "uuid",        null: false
    t.string   "identifier",  null: false
    t.string   "name",        null: false
    t.string   "url",         null: false
    t.datetime "started_at",  null: false
    t.datetime "ended_at",    null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "slido_events", ["category_id"], name: "index_slido_events_on_category_id", using: :btree
  add_index "slido_events", ["ended_at"], name: "index_slido_events_on_ended_at", using: :btree
  add_index "slido_events", ["started_at"], name: "index_slido_events_on_started_at", using: :btree
  add_index "slido_events", ["uuid"], name: "index_slido_events_on_uuid", unique: true, using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id",                      null: false
    t.integer  "question_id",                 null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "deleted",     default: false, null: false
    t.datetime "deleted_at"
    t.integer  "deletor_id"
    t.integer  "author_id",                   null: false
  end

  add_index "taggings", ["author_id"], name: "index_taggings_on_author_id", using: :btree
  add_index "taggings", ["deleted"], name: "index_taggings_on_deleted", using: :btree
  add_index "taggings", ["deletor_id"], name: "index_taggings_on_deletor_id", using: :btree
  add_index "taggings", ["question_id", "tag_id", "author_id"], name: "index_taggings_on_unique_key", unique: true, using: :btree
  add_index "taggings", ["question_id"], name: "index_taggings_on_question_id", using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
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
    t.string   "remember_token"
    t.integer  "followers_count",        default: 0,         null: false
    t.integer  "followees_count",        default: 0,         null: false
    t.integer  "evaluations_count",      default: 0,         null: false
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
    t.integer  "question_id",                 null: false
    t.integer  "viewer_id",                   null: false
    t.datetime "created_at",                  null: false
    t.boolean  "deleted",     default: false, null: false
    t.datetime "deleted_at"
    t.integer  "deletor_id"
  end

  add_index "views", ["deleted"], name: "index_views_on_deleted", using: :btree
  add_index "views", ["deletor_id"], name: "index_views_on_deletor_id", using: :btree
  add_index "views", ["question_id"], name: "index_views_on_question_id", using: :btree
  add_index "views", ["viewer_id"], name: "index_views_on_viewer_id", using: :btree

  create_table "votes", force: true do |t|
    t.integer  "voter_id",                     null: false
    t.integer  "votable_id",                   null: false
    t.string   "votable_type",                 null: false
    t.boolean  "positive",     default: true,  null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "deleted",      default: false, null: false
    t.datetime "deleted_at"
    t.integer  "deletor_id"
  end

  add_index "votes", ["deleted"], name: "index_votes_on_deleted", using: :btree
  add_index "votes", ["deletor_id"], name: "index_votes_on_deletor_id", using: :btree
  add_index "votes", ["positive"], name: "index_votes_on_positive", using: :btree
  add_index "votes", ["votable_id", "votable_type", "positive"], name: "index_votes_on_votable_id_and_votable_type_and_positive", using: :btree
  add_index "votes", ["voter_id", "votable_id", "votable_type"], name: "index_votes_on_unique_key", unique: true, using: :btree
  add_index "votes", ["voter_id"], name: "index_votes_on_voter_id", using: :btree

  create_table "watchings", force: true do |t|
    t.integer  "watcher_id",                     null: false
    t.integer  "watchable_id",                   null: false
    t.string   "watchable_type",                 null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "deleted",        default: false, null: false
    t.integer  "deletor_id"
    t.datetime "deleted_at"
  end

  add_index "watchings", ["deleted"], name: "index_watchings_on_deleted", using: :btree
  add_index "watchings", ["deletor_id"], name: "index_watchings_on_deletor_id", using: :btree
  add_index "watchings", ["watchable_id", "watchable_type"], name: "index_watchings_on_watchable_id_and_watchable_type", using: :btree
  add_index "watchings", ["watcher_id", "watchable_id", "watchable_type"], name: "index_watchings_on_unique_key", unique: true, using: :btree
  add_index "watchings", ["watcher_id"], name: "index_watchings_on_watcher_id", using: :btree

end
