class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :dfx_sastamp
      t.string :dfx_ref
      t.integer :dfx_stock
      t.index [:dfx_ref], unique: true

      t.timestamps
    end
  end
end
