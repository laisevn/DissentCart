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

  def add_product(product_id, quantity, product_info)
    existing = products.find_by(product_id: product_id)
    return if existing

    products.create!(
      product_id: product_id,
      name: product_info.name,
      unit_price: product_info.unit_price,
      quantity: quantity
    )
  end
end
