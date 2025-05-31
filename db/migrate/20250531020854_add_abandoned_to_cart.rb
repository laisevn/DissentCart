class AddAbandonedToCart < ActiveRecord::Migration[8.0]
  def change
    add_column :carts, :abandoned, :boolean, default: false, null: false
    add_column :carts, :abandoned_at, :datetime
  end
end

