class Cart::ListProducts
  attr_reader :cart_class

  def initialize(cart_class: Cart)
    @cart_class = cart_class
  end

  def call(cart_id)
    cart = find_cart(cart_id)

    if cart.products.present?
      CartSerializer.new(cart).as_json
    else
      empty_cart_response
    end
  end

  private

  # find cart with products
  def find_cart(cart_id)
    cart_class.includes(:products).find_by(id: cart_id) || raise(CartErrors::CartNotFound)
  end

  def empty_cart_response
    {
      products: [],
      total_price: 0.0
    }
  end
end
