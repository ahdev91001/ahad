# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2018_10_26_193846) do
  create_table "TESTnotesource_42", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
    t.integer "propid"
    t.text "nscleaned"
    t.text "nsraw"
  end

  create_table "additionalarchitect_42", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "propid", null: false
    t.string "name", limit: 128, null: false
    t.string "year", limit: 32
    t.string "yearflag", limit: 1
    t.index ["propid"], name: "propid"
    t.index ["yearflag"], name: "yearflag"
  end

  create_table "additionalbuilder_42", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "propid", null: false
    t.string "name", limit: 128, null: false
    t.string "year", limit: 32
    t.string "yearflag", limit: 1
    t.index ["propid"], name: "propid"
    t.index ["yearflag"], name: "yearflag"
  end

  create_table "ahdesignationvalue", primary_key: "value", id: { type: :string, limit: 128 }, charset: "latin1", force: :cascade do |t|
    t.index ["value"], name: "value", unique: true
  end

  create_table "alteration", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "propid", null: false
    t.integer "cost"
    t.string "description", limit: 128
    t.string "year", limit: 32
    t.string "yearflag", limit: 1
    t.index ["propid"], name: "propid"
    t.index ["yearflag"], name: "yearflag"
  end

  create_table "apn", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "propid", null: false
    t.string "parcel", limit: 16, null: false
    t.index ["propid"], name: "propid"
  end

  create_table "buildingpermit", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "propid", null: false
    t.string "permit", limit: 32, null: false
    t.string "year", limit: 32
    t.string "yearflag", limit: 1
    t.index ["propid"], name: "propid"
    t.index ["yearflag"], name: "yearflag"
  end

  create_table "chrscode", id: false, charset: "latin1", force: :cascade do |t|
    t.string "code", limit: 6, null: false
    t.string "description", null: false
  end

  create_table "formeraddress", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "propid", null: false
    t.string "address1", limit: 128, null: false
    t.string "address2", limit: 128, null: false
    t.string "years", limit: 64
    t.string "yearflag", limit: 1
    t.index ["propid"], name: "propid"
  end

  create_table "morgan_prop", id: false, charset: "latin1", force: :cascade do |t|
    t.integer "id", default: 0, null: false
    t.string "address1", limit: 128
    t.string "address2", limit: 128
    t.string "chrs", limit: 32
    t.string "historicname", limit: 128
    t.string "yearbuilt", limit: 32
    t.string "yearbuiltflag", limit: 1
    t.string "yearbuiltassessor", limit: 32
    t.string "photo_filename", limit: 64
  end

  create_table "morgan_prop2", id: false, charset: "latin1", force: :cascade do |t|
    t.integer "id", default: 0, null: false
    t.string "address1", limit: 128
    t.string "address2", limit: 128
    t.string "chrs", limit: 32
    t.string "historicname", limit: 128
    t.string "yearbuilt", limit: 32
    t.string "yearbuiltflag", limit: 1
    t.string "yearbuiltassessor", limit: 32
    t.string "photo_filename", limit: 64
    t.string "architect_name", limit: 128
    t.string "first_architect", limit: 1
    t.string "architect_confirmed", limit: 1
    t.string "architect_year", limit: 32
  end

  create_table "morgan_prop3", id: false, charset: "latin1", force: :cascade do |t|
    t.integer "id", default: 0, null: false
    t.string "address1", limit: 128
    t.string "address2", limit: 128
    t.string "chrs", limit: 32
    t.string "historicname", limit: 128
    t.string "yearbuilt", limit: 32
    t.string "yearbuiltflag", limit: 1
    t.string "yearbuiltassessor", limit: 32
    t.string "photo_filename", limit: 64
    t.string "architect_name", limit: 128
    t.string "first_architect", limit: 1
    t.string "architect_confirmed", limit: 1
    t.string "architect_year", limit: 32
    t.string "builder_name", limit: 128
    t.string "first_builder", limit: 1
    t.string "builder_confirmed", limit: 1
    t.string "builder_year", limit: 32
  end

  create_table "morgan_prop4", id: false, charset: "latin1", force: :cascade do |t|
    t.integer "id", default: 0, null: false
    t.string "streetnumberbegin", limit: 16
    t.string "streetnumberend", limit: 16
    t.string "streetname", limit: 64
    t.string "streetdirection", limit: 1
    t.string "addressnote", limit: 128
    t.string "address1", limit: 128
    t.string "address2", limit: 128
    t.string "ahdesignation", limit: 128
    t.string "architect_42", limit: 128
    t.string "architectconfirmed_42", limit: 1
    t.string "builder_42", limit: 128
    t.string "builderconfirmed_42", limit: 1
    t.string "chrs", limit: 32
    t.string "currentlotsize", limit: 64
    t.string "historicname", limit: 128
    t.string "legaldescription", limit: 64
    t.string "movedontoproperty", limit: 1
    t.string "originalcost", limit: 32
    t.string "originallotsize", limit: 64
    t.string "originalowner_42", limit: 64
    t.string "originalownerspouse_42", limit: 64
    t.string "originalowneroccupation", limit: 64
    t.string "placeofbusiness", limit: 64
    t.string "quadrant", limit: 32
    t.string "stories", limit: 32
    t.string "style", limit: 32
    t.string "type", limit: 32
    t.string "yearbuilt", limit: 32
    t.string "yearbuiltflag", limit: 1
    t.string "yearbuiltassessor", limit: 32
    t.string "yearbuiltassessorflag", limit: 1
    t.string "yearbuiltother", limit: 32
    t.string "yearbuiltotherflag", limit: 1
    t.string "orig_note_shpo_sources", limit: 10000
    t.string "notes_shpo_and_sources", limit: 10000
    t.string "builder_name", limit: 128
    t.string "builder_year", limit: 32
    t.string "builder_confirmed", limit: 1
  end

  create_table "otherowner_42", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "propid", null: false
    t.string "name", limit: 128, null: false
    t.string "years", limit: 32
    t.string "yearflag", limit: 1
    t.index ["propid"], name: "propid"
    t.index ["yearflag"], name: "yearflag"
  end

  create_table "photos_42", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "propid", null: false
    t.string "filename", limit: 45
    t.string "description"
    t.index ["propid"], name: "propid_index"
  end

  create_table "prop_architect", id: :integer, charset: "latin1", comment: nil, force: :cascade do |t|
    t.integer "propid"
    t.integer "architect_id"
    t.string "name", limit: 128
    t.string "first_architect", limit: 1
    t.string "confirmed", limit: 1
    t.string "year", limit: 32
    t.string "yearflag", limit: 1
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "prop_builder", id: :integer, charset: "latin1", comment: nil, force: :cascade do |t|
    t.integer "propid"
    t.integer "builder_id"
    t.string "name", limit: 128
    t.string "first_builder", limit: 1
    t.string "confirmed", limit: 1
    t.string "year", limit: 32
    t.string "yearflag", limit: 1
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "prop_chrs", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "propid", null: false
    t.string "chrs_code", limit: 20, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "prop_owner", id: :integer, charset: "latin1", comment: nil, force: :cascade do |t|
    t.integer "propid"
    t.string "name", limit: 64
    t.string "years", limit: 45
    t.string "yearflag", limit: 1
    t.string "original_owner", limit: 1
    t.string "comment", limit: 2000
    t.datetime "created_at", precision: nil
    t.datetime "modified_at", precision: nil
  end

  create_table "prop_resource", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "propid", null: false
    t.string "filename", limit: 64, null: false
    t.string "resource_type", limit: 45
    t.string "file_format", limit: 45
    t.string "description", limit: 500
    t.string "date", limit: 45
    t.string "credit", limit: 100
    t.string "primary_image", limit: 1
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["propid"], name: "propid"
  end

  create_table "property", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "streetnumberbegin", limit: 16
    t.string "streetnumberend", limit: 16
    t.string "streetname", limit: 64
    t.string "streetdirection", limit: 1
    t.string "addressnote", limit: 128
    t.string "address1", limit: 128
    t.string "address2", limit: 128
    t.string "ahdesignation", limit: 128
    t.string "architect", limit: 128
    t.string "architectconfirmed", limit: 1
    t.string "builder", limit: 128
    t.string "builderconfirmed", limit: 1
    t.string "chrs", limit: 32
    t.string "currentlotsize", limit: 64
    t.string "historicname", limit: 128
    t.string "legaldescription", limit: 64
    t.string "movedontoproperty", limit: 1
    t.string "originalcost", limit: 32
    t.string "originallotsize", limit: 64
    t.string "originalowner", limit: 64
    t.string "originalownerspouse", limit: 64
    t.string "originalowneroccupation", limit: 64
    t.string "placeofbusiness", limit: 64
    t.string "quadrant", limit: 32
    t.string "stories", limit: 32
    t.string "style", limit: 32
    t.string "type", limit: 32
    t.string "yearbuilt", limit: 32
    t.string "yearbuiltflag", limit: 1
    t.string "yearbuiltassessor", limit: 32
    t.string "yearbuiltassessorflag", limit: 1
    t.string "yearbuiltother", limit: 32
    t.string "yearbuiltotherflag", limit: 1
    t.string "orig_note_shpo_sources", limit: 10000
    t.string "notes_shpo_and_sources", limit: 10000
    t.index ["architectconfirmed"], name: "architectconfirmed"
    t.index ["builderconfirmed"], name: "builderconfirmed"
    t.index ["movedontoproperty"], name: "movedontoproperty"
    t.index ["quadrant"], name: "quadrant"
    t.index ["streetdirection"], name: "streetdirection"
    t.index ["style"], name: "style"
    t.index ["type"], name: "type"
    t.index ["yearbuiltassessorflag"], name: "yearbuiltassessorflag"
    t.index ["yearbuiltflag"], name: "yearbuiltflag"
  end

  create_table "quadrantvalue", primary_key: "value", id: { type: :string, limit: 32 }, charset: "latin1", force: :cascade do |t|
    t.index ["value"], name: "value", unique: true
  end

  create_table "scandoc", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "propid", null: false
    t.string "filename", limit: 64, null: false
    t.string "description", limit: 128
    t.index ["filename"], name: "filename", unique: true
    t.index ["propid"], name: "propid"
  end

  create_table "streetdirectionvalue", primary_key: "value", id: { type: :string, limit: 1 }, charset: "latin1", force: :cascade do |t|
    t.index ["value"], name: "value", unique: true
  end

  create_table "stylevalue", primary_key: "value", id: { type: :string, limit: 32 }, charset: "latin1", force: :cascade do |t|
    t.index ["value"], name: "value", unique: true
  end

  create_table "typevalue", primary_key: "value", id: { type: :string, limit: 32 }, charset: "latin1", force: :cascade do |t|
    t.index ["value"], name: "value", unique: true
  end

  create_table "users", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "yearflag", primary_key: "flag", id: { type: :string, limit: 1 }, charset: "latin1", force: :cascade do |t|
    t.string "description", limit: 32
    t.index ["flag"], name: "flag", unique: true
  end

  create_table "yesnoflag", primary_key: "flag", id: { type: :string, limit: 1 }, charset: "latin1", force: :cascade do |t|
    t.index ["flag"], name: "flag", unique: true
  end

  add_foreign_key "additionalarchitect_42", "property", column: "propid", name: "additionalarchitect_42_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "additionalarchitect_42", "yearflag", column: "yearflag", primary_key: "flag", name: "additionalarchitect_42_ibfk_1"
  add_foreign_key "additionalbuilder_42", "property", column: "propid", name: "additionalbuilder_42_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "additionalbuilder_42", "yearflag", column: "yearflag", primary_key: "flag", name: "additionalbuilder_42_ibfk_1"
  add_foreign_key "alteration", "property", column: "propid", name: "alteration_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "alteration", "yearflag", column: "yearflag", primary_key: "flag", name: "alteration_ibfk_1"
  add_foreign_key "apn", "property", column: "propid", name: "apn_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "buildingpermit", "property", column: "propid", name: "buildingpermit_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "buildingpermit", "yearflag", column: "yearflag", primary_key: "flag", name: "buildingpermit_ibfk_1"
  add_foreign_key "formeraddress", "property", column: "propid", name: "formeraddress_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "otherowner_42", "property", column: "propid", name: "otherowner_42_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "otherowner_42", "yearflag", column: "yearflag", primary_key: "flag", name: "otherowner_42_ibfk_1"
  add_foreign_key "prop_resource", "property", column: "propid", name: "prop_resource_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "scandoc", "property", column: "propid", name: "scandoc_ibfk_1", on_update: :cascade, on_delete: :cascade
end
