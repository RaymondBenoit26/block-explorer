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

ActiveRecord::Schema[8.0].define(version: 2025_07_06_184930) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "actions", force: :cascade do |t|
    t.bigint "transaction_id", null: false
    t.string "action_type", null: false
    t.string "sender"
    t.string "receiver"
    t.decimal "deposit", precision: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_type", "sender", "receiver"], name: "index_actions_on_action_type_and_sender_and_receiver"
    t.index ["action_type"], name: "index_actions_on_action_type"
    t.index ["transaction_id"], name: "index_actions_on_transaction_id"
  end

  create_table "blocks", force: :cascade do |t|
    t.bigint "chain_id", null: false
    t.integer "height", null: false
    t.string "block_hash", null: false
    t.datetime "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["block_hash"], name: "index_blocks_on_block_hash", unique: true
    t.index ["chain_id", "height"], name: "index_blocks_on_chain_id_and_height", unique: true
    t.index ["chain_id"], name: "index_blocks_on_chain_id"
  end

  create_table "chains", force: :cascade do |t|
    t.string "name", null: false
    t.string "api_endpoint", null: false
    t.string "api_key"
    t.integer "scale_factor", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_chains_on_name", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "block_id", null: false
    t.string "transaction_hash", null: false
    t.bigint "gas_burnt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["block_id"], name: "index_transactions_on_block_id"
    t.index ["transaction_hash"], name: "index_transactions_on_transaction_hash", unique: true
  end

  add_foreign_key "actions", "transactions"
  add_foreign_key "blocks", "chains"
  add_foreign_key "transactions", "blocks"
end
