class AddProductIdToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :product_id, :integer
    add_index :products, :product_id
  end
end
