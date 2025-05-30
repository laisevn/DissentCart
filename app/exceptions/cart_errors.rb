module CartErrors
  class CartNotFound < StandardError; end
  class ProductNotFound < StandardError; end
  class InvalidQuantity < StandardError; end
end
