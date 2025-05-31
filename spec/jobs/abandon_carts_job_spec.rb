require 'rails_helper'

RSpec.describe AbandonCartsJob, type: :job do
  it 'marca carrinho como abandonado' do
    old_cart = Cart.create!(abandoned: false, updated_at: 4.hours.ago)

    described_class.new.perform

    old_cart.reload
    expect(old_cart.abandoned).to be(true)
  end
end
