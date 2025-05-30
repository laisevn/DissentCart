require 'rails_helper'

describe CartsController do
  Rails.application.routes

  describe 'GET #show' do
    let!(:cart) { create(:cart) }

    context 'com carrinho válido' do
      let!(:products) { create_list(:product, 2, cart: cart) }

      it 'retorna carrinho com produtos' do
        get :show, params: { id: cart.id }

        expect(response).to have_http_status(:ok)
        expect(json_response[:products].map { |product| product[:id] }).to include(
          products.first.product_id,
          products.second.product_id
        )
        expect(json_response[:total_price]).to eq(products.sum(&:total_price).to_f)
      end
    end

    context 'com carrinho inválido' do
      it 'retorna erro 404' do
        get :show, params: { id: 999 }

        expect(response).to have_http_status(:not_found)
        expect(json_response[:error]).to match(/Carrinho não encontrado/)
      end
    end
  end

  describe 'POST #create' do
    let(:cart) { create(:cart) }
    let(:product) { create(:product, product_id: 345, unit_price: 1.99, name: 'Produto Teste') }

    context 'quando adiciona um produto com sucesso' do
      it 'retorna status 201' do
        post :create, params: { cart_id: cart.id, product_id: product.product_id, quantity: 1 }
        expect(response).to have_http_status(:created)
      end

      it 'retorna o carrinho com o produto adicionado' do
        post :create, params: { cart_id: cart.id, product_id: product.product_id, quantity: 1 }

        expect(json_response[:products].first[:id]).to eq(product.product_id)
        expect(json_response[:products].first[:quantity]).to eq(1)
        expect(json_response[:products].first[:unit_price]).to eq(product.unit_price.to_s)
      end
    end

    context 'quando falha ao adicionar o produto' do
      let(:invalid_product_id) { 999 }

      it 'retorna erro se o produto não existe' do
        allow(Product).to receive(:find_by).with(product_id: invalid_product_id.to_s).and_return(nil)
        post :create, params: { cart_id: cart.id, product_id: invalid_product_id, quantity: product.quantity }

        expect(response).to have_http_status(:unprocessable_content)
        expect(json_response[:error]).to include(/Produto não encontrado/)
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end
end
