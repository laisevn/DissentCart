require 'rails_helper'

describe Cart::RemoveProduct do
  subject do
    described_class.new(cart_class: cart_class)
  end

  let(:cart_class) { Cart }

  describe '#call' do
    context 'quando o carrinho não existe' do
      it 'lança o erro CartErrors::CartNotFound' do
        expect { subject.call(999, 123) }.to raise_error(CartErrors::CartNotFound)
      end
    end

    context 'quando o produto não existe no carrinho' do
      let(:cart) { create(:cart) }

      it 'lança o erro CartErrors::ProductNotFound' do
        allow(cart_class).to receive(:includes).with(:products).and_call_original

        expect { subject.call(cart.id, 123) }.to raise_error(CartErrors::ProductNotInCart)
      end
    end

    context 'quando o produto existe no carrinho' do
      let(:cart) { create(:cart) }
      let(:product) { create(:product, cart: cart) }

      it 'remove o produto do carrinho' do
        subject.call(cart.id, product.product_id)
        expect(cart.reload.products.count).to equal(0)
      end

      it 'retorna a lista atualizada sem o produto removido' do
        result = subject.call(cart.id, product.product_id)

        expect(result[:products].map { |product| product[:product_id] }).not_to include(product.product_id)
        expect(result[:total_price]).to eq(0.0)
      end
    end

    context 'quando o carrinho fica vazio após remover o último produto' do
      let!(:cart) { create(:cart) }
      let!(:product) { create(:product, cart: cart) }

      it 'retorna uma lista vazia e total_price zero' do
        result = subject.call(cart.id, product.product_id)

        expect(result[:products]).to be_empty
        expect(result[:total_price]).to eq(0.0)
      end
    end
  end
end
