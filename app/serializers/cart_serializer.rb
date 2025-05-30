class CartSerializer
  def initialize(cart)
    @cart = cart
  end

  def as_json
    {
      id: @cart.id,
      products: serialized_products,
      total_price: CartTotalCalculator.new(@cart.id).calculate
    }
  end

  private

  def serialized_products
    @cart.products.map do |product|
      {
        id: product.product_id,
        name: product.name,
        quantity: product.quantity,
        unit_price: product.unit_price,
        total_price: product.total_price
      }
    end
  end
end
