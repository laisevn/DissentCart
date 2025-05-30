# == Schema Information
#
# Table name: products
#
#  id            :bigint           not null, primary key
#  name          :string           not null
#  unit_price    :decimal          not null
#  total_price   :decimal          null
#  cart_id       :bigint           null, foreign_key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
#  Has index: index_products_on_cart_id
#
class Product < ApplicationRecord
  belongs_to :cart, optional: true

  validates :name, presence: true
  validates :unit_price, presence: true,
                         numericality: { greater_than_or_equal_to: ProductConstants::MIN_PRICE_VALIDATION }
  validates :quantity, presence: true,
                       numericality: { only_integer: true, greater_than: ProductConstants::MIN_QUANTITY_VALIDATION }

  before_validation :calculate_total_price

  private

  def calculate_total_price
    return unless unit_price.present? && quantity.present?

    self.total_price = unit_price * quantity
  end
end
