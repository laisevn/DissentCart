class Cart::MarkAsAbandoned
  def call(cart)
    cart.update!(abandoned: true, abandoned_at: Time.zone.now)
  end
end
