class CartsController < ApplicationController
  def show
    CartTotalCalculator.new(params[:id]).calculate

    cart = Cart.find_by(id: params[:id])

    if cart
      render json: CartSerializer.new(cart)
    else
      render json: { error: 'Carrinho não encontrado' }, status: :not_found
    end
  end

  def create
    cart = Cart.find_or_create_by(id: params[:cart_id])
    result = Cart::AddProduct.new.call(cart.id, params[:product_id], params[:quantity])

    render json: CartSerializer.new(result), status: :created
  rescue CartErrors::ProductNotFound
    render json: { error: 'Produto não encontrado' }, status: :unprocessable_entity
  rescue CartErrors::InvalidQuantity => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
