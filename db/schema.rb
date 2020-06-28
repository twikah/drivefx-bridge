# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_28_141553) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "products", force: :cascade do |t|
    t.string "dfx_ref"
    t.integer "dfx_stock"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "dfx_color"
    t.string "dfx_size"
    t.string "dfx_gender"
    t.string "dfx_origin_ref"
    t.string "dfx_title"
    t.string "dfx_vendor"
    t.string "dfx_type"
    t.decimal "dfx_price_1", precision: 8, scale: 2
    t.decimal "dfx_price_2", precision: 8, scale: 2
    t.boolean "dfx_vat_included_1"
    t.boolean "dfx_vat_included_2"
    t.decimal "dfx_cost_price", precision: 8, scale: 2
    t.string "dfx_family"
    t.string "dfx_barcode"
    t.integer "dfx_net_weight"
    t.text "dfx_description"
    t.index ["dfx_ref"], name: "index_products_on_dfx_ref", unique: true
  end

  create_table "shops", force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

end
