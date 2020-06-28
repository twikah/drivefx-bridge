class AddFamilyToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :dfx_family, :string
  end
end
