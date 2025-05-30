class Cart::RemoveProduct
  attr_reader :cart_class

  def initialize(cart_class: Cart)
    @cart_class = cart_class
  end

  def call(cart_id, product_id)
    cart = find_cart(cart_id)
    product = find_product_in_cart(cart, product_id)

    product.destroy!
    cart.reload

    CartSerializer.new(cart).as_json
  end

  private

  def find_cart(cart_id)
    cart_class.find_by(id: cart_id) || raise(CartErrors::CartNotFound)
  end

  def find_product_in_cart(cart, product_id)
    cart.products.find_by(product_id: product_id) || raise(CartErrors::ProductNotFound)
  end
end
