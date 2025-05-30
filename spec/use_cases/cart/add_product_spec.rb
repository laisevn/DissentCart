require 'rails_helper'

describe Cart::AddProduct do
  subject do
    described_class.new(
      cart_class: cart_class,
      product_class: product_class
    )
  end

  let(:cart_class) { Cart }
  let(:product_class) { Product }

  describe '#call' do
    context 'quando carrinho não existe' do
      it 'lança erro CartNotFound' do
        expect { subject.call(999, 123, 2) }.to raise_error(CartErrors::CartNotFound)
      end
    end

    context 'quando produto não existe' do
      let(:cart) { create(:cart) }

      it 'lança erro ProductNotFound' do
        expect { subject.call(cart.id, 123, 2) }.to raise_error(CartErrors::ProductNotFound)
      end
    end

    context 'com quantidade inválida' do
      let(:cart) { create(:cart) }
      let(:product) { create(:product) }

      it 'levanta erro InvalidQuantity' do
        expect do
          subject.call(cart.id, product.id, -1)
        end.to raise_error(CartErrors::InvalidQuantity)
      end
    end

    context 'com dados válidos' do
      let(:cart) { create(:cart) }
      let(:product) { create(:product) }

      it 'adiciona produto ao carrinho' do
        expect do
          subject.call(cart.id, product.id, 2)
        end.to change { cart.products.count }.by(1)
      end
    end
  end
end
