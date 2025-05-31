class Cart::UpdateItemQuantity < BaseService
  def call(cart_id, product_id, quantity)
    cart = find_cart(cart_id)
    product = find_product_in_cart(cart, product_id)

    validate_quantity(quantity)

    product.update!(quantity: quantity.to_i + product.quantity)
    cart.reload
    cart
  end
end
