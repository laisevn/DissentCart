require 'rails_helper'

describe CartsController do
  Rails.application.routes

  # describe 'GET #index' do
  #   it 'retorna sucesso' do
  #     get :index

  #     expect(response).to have_http_status(:ok)
  #   end

  #   it 'retorna uma lista vazia de carrinhos' do
  #     get :index

  #     expect(json_response).to eq([])
  #   end
  # end

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
        # allow(Cart::ListProducts).to receive(:new).and_raise(CartErrors::CartNotFound)

        get :show, params: { id: 999 }

        expect(response).to have_http_status(:not_found)
        expect(json_response[:error]).to match(/Carrinho não encontrado/)
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end
end
