# == Schema Information
#
# Table name: carts
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  abandoned    :boolean          default(FALSE), not null
#  abandoned_at :datetime

class Cart < ApplicationRecord
  has_many :products, dependent: :destroy

  scope :active, -> { where(abandoned: false) }
  scope :not_updated_for, ->(time) { where(updated_at: ...(time.ago)) }

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
