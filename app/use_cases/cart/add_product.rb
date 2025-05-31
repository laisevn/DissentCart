class Cart::AddProduct < BaseService
  def call(cart_id, product_id, quantity)
    cart = find_cart(cart_id)

    raise CartErrors::ProductAlreadyInCart, 'Produto já está no carrinho' if product_in_cart?(cart, product_id)

    product = find_product(product_id)

    validate_quantity(quantity)
    cart.add_product(product_id, quantity, product)
    cart.reload
    cart
  end

  private

  def product_in_cart?(cart, product_id)
    cart.products.find_by(product_id: product_id)
  end
end
