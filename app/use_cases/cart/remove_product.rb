class Cart::RemoveProduct < BaseService
  def call(cart_id, product_id)
    cart = find_cart(cart_id)
    product = find_product_in_cart(cart, product_id)

    product.destroy!
    cart.reload

    CartSerializer.new(cart).as_json
  end
end
