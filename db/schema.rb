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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120924204211) do

  create_table "activities", :force => true do |t|
    t.string   "activity"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "buildings", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
    t.string   "code"
    t.integer  "osuid"
  end

  create_table "buildings_networks", :id => false, :force => true do |t|
    t.integer "building_id"
    t.integer "network_id"
  end

  add_index "buildings_networks", ["building_id", "network_id"], :name => "index_buildings_networks_on_building_id_and_network_id", :unique => true
  add_index "buildings_networks", ["network_id"], :name => "index_buildings_networks_on_network_id"

  create_table "devices", :force => true do |t|
    t.integer  "network_id"
    t.integer  "ip",          :limit => 8
    t.text     "description"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "type_id"
    t.string   "hostname"
  end

  create_table "dhcp_servers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "networks", :force => true do |t|
    t.integer  "network",        :limit => 8
    t.integer  "mask",           :limit => 8
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "description"
    t.integer  "gateway",        :limit => 8
    t.integer  "dhcp_server_id"
    t.integer  "vlan"
  end

  create_table "types", :force => true do |t|
    t.text "name"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "network_id"
    t.string   "emplid"
    t.string   "name_n"
  end

end
