require 'rails_helper'

describe Cart::ListProducts do
  subject do
    described_class.new(
      cart_class: cart_class
    )
  end

  let(:cart_class) { Cart }

  describe '#call' do
    context 'quando não existe produtos no carrinho' do
      let(:cart) { create(:cart) }

      it 'retorna uma lista vazia' do
        allow(cart_class).to receive(:find_by).with(id: cart.id).and_return([])

        result = subject.call(cart.id)
        expect(result).to eq(
          {
            products: [],
            total_price: 0.0
          }
        )
      end
    end

    context 'quando existe produtos no carrinho' do
      let!(:cart) { create(:cart) }

      let!(:product_list) { create_list(:product, 2, cart_id: cart.id) }
      let(:product_one) { product_list.first }
      let(:product_two) { product_list.second }

      it 'retorna uma lista de produtos formatada' do
        expected_result = [
          {
            id: product_one.product_id,
            name: product_one.name,
            unit_price: product_one.unit_price,
            quantity: product_one.quantity,
            total_price: product_one.total_price
          },
          {
            id: product_two.product_id,
            name: product_two.name,
            unit_price: product_two.unit_price,
            quantity: product_two.quantity,
            total_price: product_two.total_price
          }
        ]

        result = subject.call(cart.id)

        expect(result[:products]).to match_array(expected_result)
        expect(result[:total_price]).to eq(product_list.sum(&:total_price))
      end
    end

    context 'quando o carrinho não existe' do
      it 'lança o erro CartErrors::CartNotFound' do
        expect { subject.call(999) }.to raise_error(CartErrors::CartNotFound)
      end
    end
  end
end
