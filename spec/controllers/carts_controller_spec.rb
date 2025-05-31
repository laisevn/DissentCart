require 'rails_helper'

describe CartsController do
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

  describe 'POST #add_item' do
    context 'quando o produto já está no carrinho' do
      let!(:cart) { create(:cart) }
      let!(:product_x) do
        create(:product, name: 'Produto X', unit_price: 7.00, quantity: 2)
      end

      before do
        cart.add_product(product_x.product_id, product_x.quantity, product_x)
        session[:cart_id] = cart.id
      end

      it 'atualiza a quantidade corretamente' do
        expect do
          post :add_item, params: { product_id: product_x.product_id, quantity: 1 }
        end.to change {
          cart.reload.products.find_by(product_id: product_x.product_id)&.quantity
        }.from(2).to(3)

        json = json_response
        expect(json[:products].first[:quantity]).to eq(3)
      end

      it 'retorna status 200 OK' do
        post :add_item, params: { product_id: product_x.product_id, quantity: 1 }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'quando o produto não está no carrinho' do
      let!(:cart) { create(:cart) }
      let!(:new_product) do
        create(:product, product_id: 456, name: 'Produto Novo', unit_price: 5.0)
      end

      before { session[:cart_id] = cart.id }

      it 'não adiciona o produto (deve usar POST /cart)' do
        post :add_item, params: { product_id: new_product.product_id, quantity: 2 }
        expect(response).to have_http_status(422)
        expect(json_response[:error]).to match(/Produto não encontrado/)
      end
    end
  end

  describe 'DELETE #delete_item' do
    let!(:cart) { create(:cart) }
    let!(:existing_product) do
      create(:product, name: 'ProdutoADeletar', unit_price: 7.00, quantity: 2)
    end

    before do
      cart.add_product(existing_product.product_id, existing_product.quantity, existing_product)
      session[:cart_id] = cart.id
    end

    context 'quando o produto NÃO existe' do
      it 'retorna erro de produto não encontrado' do
        allow(Product).to receive(:find_by).with(product_id: 999).and_return(nil)

        delete :delete_item, params: { id: 999 }

        expect(response).to have_http_status(422)
        expect(json_response[:error]).to eq('Produto não encontrado no carrinho')
      end
    end

    context 'quando o produto existe mas NÃO tem carrinho' do
      let!(:orphaned_product) do
        create(:product, name: 'Produto Z', unit_price: 5.00, quantity: 1, cart: nil)
      end

      it 'retorna erro de produto sem carrinho' do
        delete :delete_item, params: { id: orphaned_product.product_id }

        expect(response).to have_http_status(422)
        expect(json_response[:error]).to eq('Produto não encontrado no carrinho')
      end
    end

    context 'quando o produto existe mas está em outro carrinho' do
      let!(:other_cart) { create(:cart) }
      let!(:other_product) do
        create(:product, name: 'ProdutoEmOutroCart', unit_price: 9.90, quantity: 1)
      end

      before do
        other_cart.add_product(other_product.product_id, other_product.quantity, other_product)
      end

      it 'não remove produto de outro carrinho' do
        expect do
          delete :delete_item, params: { id: other_product.product_id }
          cart.reload
        end.not_to change(cart.products, :count)

        expect(response).to have_http_status(422)
        expect(json_response[:error]).to eq('Produto não encontrado no carrinho')
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end
end
