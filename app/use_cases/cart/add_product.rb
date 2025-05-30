class Cart::AddProduct
  attr_reader :cart_class, :product_class

  def initialize(product_class: Product, cart_class: Cart)
    @product_class = product_class
    @cart_class = cart_class
  end

  def call(cart_id, product_id, quantity)
    cart = find_cart(cart_id)
    product = find_product(product_id)

    validate_quantity(quantity)

    cart.add_product(product_id, quantity, product)
    cart.save!

    cart.reload
  end

  private

  def find_cart(cart_id)
    cart_class.find_by(id: cart_id) || raise(CartErrors::CartNotFound)
  end

  def find_product(product_id)
    product_class.find_by(product_id: product_id) || raise(CartErrors::ProductNotFound)
  end

  def validate_quantity(quantity)
    return if quantity.to_i.positive?

    raise CartErrors::InvalidQuantity, "Quantidade inválida: #{quantity}"
  end
end
