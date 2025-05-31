require 'rails_helper'

describe Cart::MarkAsAbandoned do
  describe '#call' do
    let(:cart) { Cart.create!(abandoned: false, abandoned_at: nil) }

    it 'marca o carrinho como abandonado' do
      described_class.new.call(cart)

      cart.reload
      expect(cart.abandoned).to be(true)
      expect(cart.abandoned_at).not_to be_nil
      expect(cart.abandoned_at).to be_within(1.second).of(Time.zone.now)
    end
  end
end
