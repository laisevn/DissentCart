class CartTotalCalculator
  def initialize(cart_id)
    @cart_id = cart_id
    @cache_key = "cart:#{@cart_id}:total_price"
  end

  def calculate
    Rails.cache.fetch(@cache_key, expires_in: 5.minutes) do
      force_calculate
    end
  end

  def recalculate
    force_calculate.tap do |total|
      Rails.cache.write(@cache_key, total)
    end
  end

  private

  def force_calculate
    Product.where(cart_id: @cart_id).sum(:total_price).to_f
  end
end
