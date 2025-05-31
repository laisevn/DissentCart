module CartErrors
  class CartNotFound < StandardError; end
  class ProductNotFound < StandardError; end
  class InvalidQuantity < StandardError; end
  class ProductAlreadyInCart < StandardError; end
  class ProductNotInCart < StandardError; end
end
