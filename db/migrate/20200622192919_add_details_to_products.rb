class AddDetailsToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :dfx_color, :string
    add_column :products, :dfx_size, :string
    add_column :products, :dfx_gender, :string
    add_column :products, :dfx_origin_ref, :string
    add_column :products, :dfx_title, :string
    add_column :products, :dfx_vendor, :string
    add_column :products, :dfx_type, :string
    add_column :products, :dfx_price_1, :decimal, precision: 8, scale: 2
    add_column :products, :dfx_price_2, :decimal, precision: 8, scale: 2
    add_column :products, :dfx_vat_included_1, :boolean
    add_column :products, :dfx_vat_included_2, :boolean
    add_column :products, :dfx_cost_price, :decimal, precision: 8, scale: 2
  end
end
