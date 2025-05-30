class ChangeCartIdInProducts < ActiveRecord::Migration[8.0]
  def up
    change_column_null :products, :cart_id, true
  end

  def down
    change_column_null :products, :cart_id, false
  end
end
