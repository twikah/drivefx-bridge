class RemoveDfxSastampFromProducts < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :dfx_sastamp, :string
  end
end
