class AddRazorpayPaymentIdToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :razorpay_payment_id, :string
  end
end
