class Api::V1::Customer::OrdersController < Api::V1::Customer::BaseController
  before_action :set_vendor, only: :create
  before_action :setup_razorpay_account, only: :create
  before_action :set_amount, only: :create
  def index; end

  def show; end

  def create
    ActiveRecord::Base.transaction do
      razorpay_order = Razorpay::Order.create(amount: @amount, currency: 'INR')
      unless razorpay_order.present? && razorpay_order.attributes['id'].present?
        return render json: { message: 'Failed to create order, please try in sometime.' },
                      status: :unprocessable_entity
      end
      order = Order.new(order_params)
      order.customer = current_customer
      order.vendor = @vendor
      order.razorpay_order_id = razorpay_order.attributes['id']
      if order.save
        render json: { order:, message: 'Your order has been reached to the vendor' }, status: :created
      else
        render json: { error: order.errors.full_messages }, status: :unprocessable_entity
      end
    end
  rescue StandardError => e
    render json: { message: e }, status: :unprocessable_entity
  end

  def update; end

  def destroy; end

  private

  def set_vendor
    @vendor = Vendor.find_by_id(order_params[:vendor_id])
    render json: { message: 'Vendor not found' }, status: :not_found unless @vendor
  end

  def setup_razorpay_account
    setup_details = Payment.new(@vendor).razorpay_setup
    return if setup_details

    render json: { message: 'could not intialize your razorpay account, please try after sometime.' },
           status: :unprocessable_entity
  end

  def set_amount
    @amount = order_params[:amount_to_be_paid]
    render json: { message: 'Please include the amount' }, status: :unprocessable_entity unless @amount
  end

  def order_params
    params.require(:order).permit(:vendor_id, :amount_to_be_paid, :total_items, food_items_details: {})
  end
end
