class AddBarcodeToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :dfx_barcode, :string
    add_column :products, :dfx_net_weight, :integer
    add_column :products, :dfx_description, :text
  end
end
