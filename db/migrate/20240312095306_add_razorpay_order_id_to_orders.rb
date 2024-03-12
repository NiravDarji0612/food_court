class AddRazorpayOrderIdToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :razorpay_order_id, :string, default: ""
  end
end
