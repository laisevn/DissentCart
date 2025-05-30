class CartsController < ApplicationController
  include ActionController::Cookies

  def show
    CartTotalCalculator.new(params[:id]).calculate

    cart = Cart.find_by(id: params[:id])

    if cart
      render json: CartSerializer.new(cart).as_json
    else
      render json: { error: 'Carrinho não encontrado' }, status: :not_found
    end
  end

  def create
    cart = current_or_create_cart
    Cart::AddProduct.new.call(cart.id, params[:product_id], params[:quantity])
    cart.reload

    render json: CartSerializer.new(cart).as_json, status: :created
  rescue CartErrors::ProductNotFound
    render json: { error: 'Produto não encontrado' }, status: :unprocessable_entity
  rescue CartErrors::InvalidQuantity => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def current_or_create_cart
    @current_or_create_cart ||= if session[:cart_id]
                                  Cart.find_by(id: session[:cart_id]) || create_cart
                                else
                                  create_cart
                                end
  end

  def create_cart
    cart = Cart.create!
    session[:cart_id] = cart.id
    cart
  end
end
