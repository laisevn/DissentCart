class CartsController < ApplicationController
  def show
    CartTotalCalculator.new(params[:id]).calculate

    cart = Cart.find_by(id: params[:id])

    if cart
      render json: CartSerializer.new(cart).as_json
    else
      render json: { error: 'Carrinho não encontrado' }, status: :not_found
    end
  end
end
