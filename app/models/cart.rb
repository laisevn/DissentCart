# == Schema Information
#
# Table name: carts
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Cart < ApplicationRecord
  has_many :products, dependent: :destroy

  def add_product(product_id, quantity, product)
    products.create!(
      product_id: product_id,
      name: product.name,
      unit_price: product.unit_price,
      quantity: quantity
    )
  end
end
