require 'rails_helper'

describe CartsController, type: :controller do
  Rails.application.routes

  describe 'GET #show' do
    let(:cart) { create(:cart) }

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
    let(:product) do
      create(:product, cart: nil, product_id: 345, unit_price: 1.99, name: 'Produto Teste', quantity: 1)
    end

    before { session[:cart_id] = nil }

    context 'quando adiciona um produto com sucesso' do
      it 'cria um novo carrinho na primeira requisição' do
        expect do
          post :create, params: { product_id: product.product_id, quantity: 1 }
        end.to change(Cart, :count).by(1)
      end

      it 'usa o mesmo carrinho em requisições subsequentes' do
        post :create, params: { product_id: product.product_id, quantity: 1 }
        first_cart_id = session[:cart_id]

        post :create, params: { product_id: product.product_id, quantity: 1 }

        expect(session[:cart_id]).to eq(first_cart_id)
        expect(Cart.count).to eq(1)
      end

      it 'retorna o carrinho com o produto adicionado' do
        post :create, params: { product_id: product.product_id, quantity: 2 }

        json = json_response
        expect(json[:id]).to eq(session[:cart_id])
        expect(json[:products].first[:quantity]).to eq(2)
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end
end
