require 'rails_helper'

describe DeleteAbandonedCartsJob do
  let!(:recent_cart) do
    create(:cart, abandoned: true, abandoned_at: 6.days.ago)
  end

  let!(:old_cart) do
    create(:cart, abandoned: true, abandoned_at: 8.days.ago)
  end

  let!(:active_cart) do
    create(:cart, abandoned: false, abandoned_at: nil)
  end

  it 'remove apenas carrinhos abandonados há mais de 7 dias' do
    expect do
      described_class.new.perform
    end.to change(Cart, :count).by(-1)

    expect(Cart.exists?(old_cart.id)).to be(false)
  end

  it 'não remove carrinhos ativos' do
    expect(Cart.exists?(recent_cart.id)).to be(true)
    expect(Cart.exists?(active_cart.id)).to be(true)
  end
end
