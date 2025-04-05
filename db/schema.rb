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

ActiveRecord::Schema.define(version: 20181026193846) do

  create_table "additionalarchitect", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "id",                   null: false
    t.integer "propid",               null: false
    t.string  "name",     limit: 128, null: false
    t.string  "year",     limit: 32
    t.string  "yearflag", limit: 1
  end

  create_table "additionalbuilder", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "id",                   null: false
    t.integer "propid",               null: false
    t.string  "name",     limit: 128, null: false
    t.string  "year",     limit: 32
    t.string  "yearflag", limit: 1
  end

  create_table "ahdesignationvalue", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "value", limit: 128, null: false
  end

  create_table "alteration", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "id",                      null: false
    t.integer "propid",                  null: false
    t.integer "cost"
    t.string  "description", limit: 128
    t.string  "year",        limit: 32
    t.string  "yearflag",    limit: 1
  end

  create_table "apn", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "id",                null: false
    t.integer "propid",            null: false
    t.string  "parcel", limit: 16, null: false
  end

  create_table "buildingpermit", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "id",                  null: false
    t.integer "propid",              null: false
    t.string  "permit",   limit: 32, null: false
    t.string  "year",     limit: 32
    t.string  "yearflag", limit: 1
  end

  create_table "chrscode", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "code", limit: 6, null: false
  end

  create_table "formeraddress", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "id",                   null: false
    t.integer "propid",               null: false
    t.string  "address1", limit: 128, null: false
    t.string  "address2", limit: 128, null: false
    t.string  "years",    limit: 64
    t.string  "yearflag", limit: 1
  end

  create_table "otherowner", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "id",                   null: false
    t.integer "propid",               null: false
    t.string  "name",     limit: 128, null: false
    t.string  "years",    limit: 32
    t.string  "yearflag", limit: 1
  end

  create_table "photo", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "id",                      null: false
    t.integer "propid",                  null: false
    t.string  "filename",    limit: 64,  null: false
    t.string  "description", limit: 128
  end

  create_table "photos", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "id",                     null: false
    t.integer "propid",                 null: false
    t.string  "filename",    limit: 45
    t.string  "description"
  end

  create_table "property", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "streetnumberbegin",       limit: 16
    t.string "streetnumberend",         limit: 16
    t.string "streetname",              limit: 64
    t.string "streetdirection",         limit: 1
    t.string "addressnote",             limit: 128
    t.string "address1",                limit: 128
    t.string "address2",                limit: 128
    t.string "ahdesignation",           limit: 128
    t.string "architect",               limit: 128
    t.string "architectconfirmed",      limit: 1
    t.string "builder",                 limit: 128
    t.string "builderconfirmed",        limit: 1
    t.string "chrs",                    limit: 32
    t.string "currentlotsize",          limit: 64
    t.string "historicname",            limit: 128
    t.string "legaldescription",        limit: 64
    t.string "movedontoproperty",       limit: 1
    t.string "originalcost",            limit: 32
    t.string "originallotsize",         limit: 64
    t.string "originalowner",           limit: 64
    t.string "originalownerspouse",     limit: 64
    t.string "originalowneroccupation", limit: 64
    t.string "placeofbusiness",         limit: 64
    t.string "quadrant",                limit: 32
    t.string "stories",                 limit: 32
    t.string "style",                   limit: 32
    t.string "type",                    limit: 32
    t.string "yearbuilt",               limit: 32
    t.string "yearbuiltflag",           limit: 1
    t.string "yearbuiltassessor",       limit: 32
    t.string "yearbuiltassessorflag",   limit: 1
    t.string "yearbuiltother",          limit: 32
    t.string "yearbuiltotherflag",      limit: 1
    t.string "orig_note_shpo_sources",  limit: 10000
    t.string "notes_shpo_and_sources",  limit: 10000
    t.index ["architectconfirmed"], name: "architectconfirmed", using: :btree
    t.index ["builderconfirmed"], name: "builderconfirmed", using: :btree
    t.index ["movedontoproperty"], name: "movedontoproperty", using: :btree
    t.index ["quadrant"], name: "quadrant", using: :btree
    t.index ["streetdirection"], name: "streetdirection", using: :btree
    t.index ["style"], name: "style", using: :btree
    t.index ["type"], name: "type", using: :btree
    t.index ["yearbuiltassessorflag"], name: "yearbuiltassessorflag", using: :btree
    t.index ["yearbuiltflag"], name: "yearbuiltflag", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",           default: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

end
