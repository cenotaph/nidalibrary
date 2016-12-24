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

ActiveRecord::Schema.define(version: 20161224140806) do

  create_table "books", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "isbn10"
    t.string   "isbn13"
    t.string   "title",              limit: 512
    t.string   "language"
    t.string   "publisher"
    t.integer  "pages"
    t.integer  "year_published"
    t.string   "author",             limit: 512
    t.string   "subtitle"
    t.text     "comment",            limit: 65535
    t.string   "catno"
    t.string   "provenance"
    t.string   "slug",               limit: 512
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "section_id"
    t.string   "image"
    t.string   "image_content_type"
    t.integer  "image_size"
    t.integer  "image_width"
    t.integer  "image_height"
    t.text     "summary",            limit: 65535
    t.integer  "status_id",                        default: 1, null: false
    t.index ["section_id"], name: "index_books_on_section_id", using: :btree
    t.index ["status_id"], name: "index_books_on_status_id", using: :btree
  end

  create_table "sections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.string   "colour",     limit: 7
    t.string   "slug"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "statuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.string   "colour",     limit: 7
    t.string   "slug"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
