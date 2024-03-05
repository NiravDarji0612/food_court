class Api::V1::Customer::CartsController < Api::V1::Customer::BaseController
  # skip_before_action :doorkeeper_authorize!, only: %i[add_to_cart]
  before_action :current_customer
  before_action :set_cart, except: %i[create]
  # before_action :customer?

  def cart
    render json: { cart: @cart, message: 'cart has been fetched successfully' }, status: :ok
  end

  def create
    cart = current_customer.cart || current_customer.create_cart
    render json: { cart:, message: 'Cart has been created successfully' }
  end


  def update
    if @cart.update(cart_params)
      render json: { cart: @cart, message: 'cart has been updated successfully' }, status: :ok
    else
      render json: { error: @cart.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @cart.destroy
      render json: { message: 'Cart has been deleted successfully' }, status: :ok
    else
      render json: { message: 'Something went wrong, Please try again' }, status: :unprocessable_entity
    end
  end

  private

  def cart_params
    params.require(:cart).permit(:final_price)
  end

  def set_cart
    @cart = current_customer.cart
    render json: { message: 'cart has not been found' }, status: :not_found unless @cart
  end
end
