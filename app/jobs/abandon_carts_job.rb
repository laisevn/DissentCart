class AbandonCartsJob
  include Sidekiq::Job

  def perform
    carts_to_abandon = Cart.not_updated_for(CartConstants::ABANDONMENT_TIME).active

    carts_to_abandon.each do |cart|
      Cart::MarkAsAbandoned.new.call(cart)
    end
  end
end
