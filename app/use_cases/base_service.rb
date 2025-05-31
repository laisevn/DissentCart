# BaseService provides common functionality for all service classes in the application.
# It includes methods for finding carts and products, validating quantities, and handling errors.
class BaseService
  attr_reader :cart_class, :product_class

  def initialize(cart_class: Cart, product_class: Product)
    @cart_class = cart_class
    @product_class = product_class
  end

  protected

  def find_cart(cart_id)
    cart_class.find_by(id: cart_id) || raise(CartErrors::CartNotFound)
  end

  def find_product(product_id)
    product_class.find_by(product_id: product_id) || raise(CartErrors::ProductNotFound)
  end

  def find_product_in_cart(cart, product_id)
    cart.products.find_by(product_id: product_id) || raise(CartErrors::ProductNotInCart)
  end

  def validate_quantity(quantity)
    quantity_int = quantity.to_i
    return if quantity_int.positive?

    raise CartErrors::InvalidQuantity, "Quantidade inválida: #{quantity}"
  end
end
