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

ActiveRecord::Schema.define(version: 20150813161144) do

  create_table "active_payment_transactions", force: :cascade do |t|
    t.integer  "amount"
    t.string   "currency"
    t.string   "reference_number"
    t.string   "external_id"
    t.integer  "payee_id"
    t.integer  "payer_id"
    t.integer  "payable_id"
    t.string   "payable_type"
    t.string   "gateway"
    t.integer  "source"
    t.integer  "state"
    t.text     "metadata"
    t.string   "ip_address"
    t.datetime "paid_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
