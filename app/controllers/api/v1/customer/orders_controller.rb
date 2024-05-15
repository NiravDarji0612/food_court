class Api::V1::Customer::OrdersController < Api::V1::Customer::BaseController
  before_action :set_vendor, only: :create
  before_action :setup_razorpay_account, only: :create
  before_action :set_amount, only: :create

  def index
    @orders = current_customer.orders
    @orders = orders.map{|order| order.attributes.merge({stall_name: order.vendor.stall_name})}
    return render json: { orders: @orders, message: "Orders has been fetched successfully" }, status: :ok if @orders
    render json: { orders: "orders has not been found"}, status: :ok
  end

  def show; end

  def create
    ActiveRecord::Base.transaction do
      razorpay_order = Razorpay::Order.create(amount: @amount * 100, currency: 'INR')
      unless razorpay_order.present? && razorpay_order.attributes['id'].present?
        return render json: { message: 'Failed to create order, please try in sometime.' },
                      status: :unprocessable_entity
      end
      order = Order.new(order_params)
      order.customer = current_customer
      order.vendor = @vendor
      order.razorpay_order_id = razorpay_order.attributes['id']
      if order.save
        render json: { order:, message: 'Order has been initiated' }, status: :created
      else
        render json: { error: order.errors.full_messages }, status: :unprocessable_entity
      end
    end
  rescue StandardError => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  def callback
    order_id = params["order_id"]
    payment_id = params["payment_id"]

    razorpay_order = Razorpay::Order.fetch(order_id)


    if razorpay_order.attributes['status'] == 'paid'
      ActiveRecord::Base.transaction do
        @order = Order.find_by(razorpay_order_id: order_id)
        if @order.present?
          @order.update(payment_status: 'paid', razorpay_payment_id: payment_id)

          @order.cart_items << current_customer.cart.cart_items.joins(food_item: { vendor_category: :vendor }).where("vendors.id = ?", @order.vendor_id)

          @order.update(food_items_details:  @order.cart_items.map{|c| {name: c.food_item.name, category: c.food_item.item_type, type: c.sub_type, quantity: c.quantity,amount: c.food_item.price} })
          @order.cart_items.destroy_all
          render json: { order: @order, message: "Payment is done successfully"}, status: :ok
        else
          render json: { message: "Order not found" }, status: :not_found
        end
      end
    else
      render json: { message: "Payment failed, please try again!!!" }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  def update; end

  def destroy; end

  private

  def set_vendor
    @vendor = Vendor.find_by_id(params[:order][:vendor_id])
    render json: { message: 'Vendor not found' }, status: :not_found unless @vendor
  end

  def setup_razorpay_account
    setup_details = Payment.new(@vendor).razorpay_setup
    return if setup_details

    render json: { message: 'could not intialize your razorpay account, please try after sometime.' }, status: :unprocessable_entity
  end

  def set_amount
    @amount = order_params[:amount_to_be_paid]
    render json: { message: 'Please include the amount' }, status: :unprocessable_entity unless @amount
  end

  def order_params
    params.require(:order).permit(:vendor_id, :amount_to_be_paid, :total_items)
  end
end
