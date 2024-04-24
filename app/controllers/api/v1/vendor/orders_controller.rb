class Api::V1::Vendor::OrdersController < Api::V1::Vendor::BaseController
  before_action :set_order, except: %i[index]
  def index
    orders = @current_vendor.orders
    unless orders.empty?
      render json: { orders:, message: "Your orders has been fetched successfully."}, status: :ok
    else
      render json: { message: "No orders available at the moment"}, status: :ok
    end
  end

  def accept_order
    if @order.update(status: 1)
      render json: { order: @order, message: "Order has been accepted and status changed to preparing.."}, status: :ok
    else
      render json: { message: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def reject_order
    if @order.update(status: 2)
      render json: { order: @order, message: "Order has been rejected"}, status: :ok
    else
      render json: { message: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def preparing_order
    if @order.update(status: 3)
      render json: { message: "Order is preparing..."}, status: :ok
    else
      render json: { message: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def ready_for_delivery_order
    if @order.update(status: 4)
      render json: { message: "Order is ready for delivery"}, status: :ok
    else
      render json: { message: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find_by_id(params[:order_id]) || Order.find_by(token_number: params[:token_number])
    return render json: { message: "Order not found" }, status: :not_found unless @order
  end
end
