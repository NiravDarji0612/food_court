class Api::V1::Customer::CartItemsController < Api::V1::Customer::BaseController
  before_action :set_cart
  before_action :set_cart_item, only: %i[destroy update]

  def create
    cart_item = CartItem.new(cart_item_params)
    cart_item.cart = @cart
    if cart_item.save
      render json: { message: 'item has been added to the cart' }, status: :ok
    else
      render json: { error: cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @cart_item.update(cart_item_params)
      render json: { cart: @cart, message: 'item has been updated successfully.' }, status: :ok
    else
      render json: { error: @cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @cart_item.destroy
      render json: { message: 'cart item has been removed successfully' }, status: :ok
    else
      render json: { error: @cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:food_item_id, :quantity, :price)
  end

  def set_cart
    @cart = current_customer.cart
    render json: { message: 'Cart has not been found' }, status: :not_found unless @cart
  end

  def set_cart_item
    @cart_item = current_customer.cart.cart_items.find_by_id(params[:id])
    render json: { message: 'Cart item has not been found' }, status: :not_found unless @cart_item
  end
end
