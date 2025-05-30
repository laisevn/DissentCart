class Cart::UpdateItemQuantity
  attr_reader :cart_class, :product_class

  def initialize(cart_class: Cart)
    @cart_class = cart_class
  end

  def call(cart_id, product_id, quantity)
    cart = find_cart(cart_id)
    product = find_product(cart, product_id)

    validate_quantity(quantity)

    product.update!(quantity: quantity.to_i + product.quantity)
    cart.reload
    cart
  end

  private

  def find_cart(cart_id)
    cart_class.find_by(id: cart_id) || raise(CartErrors::CartNotFound)
  end

  def find_product(cart, product_id)
    cart.products.find_by(product_id: product_id) || raise(CartErrors::ProductNotFound)
  end

  def validate_quantity(quantity)
    quantity_int = quantity.to_i
    return quantity if quantity_int.positive?

    raise CartErrors::InvalidQuantity, "Quantidade inválida: #{quantity}"
  end
end
