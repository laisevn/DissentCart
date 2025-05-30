class Cart::AddProduct
  attr_reader :cart_class, :product_class

  def initialize(product_class: Product, cart_class: Cart)
    @product_class = product_class
    @cart_class = cart_class
  end

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

  def find_cart(cart_id)
    cart_class.find_by(id: cart_id) || raise(CartErrors::CartNotFound)
  end

  def find_product(product_id)
    product_class.find_by(product_id: product_id) || raise(CartErrors::ProductNotFound)
  end

  def product_in_cart?(cart, product_id)
    cart.products.find_by(product_id: product_id)
  end

  def validate_quantity(quantity)
    quantity_int = quantity.to_i
    return if quantity_int.positive?

    raise CartErrors::InvalidQuantity, "Quantidade inválida: #{quantity}"
  end
end
