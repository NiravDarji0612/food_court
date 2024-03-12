class AddRazorpayKeyIdAndRazorpaySecretIdToVendors < ActiveRecord::Migration[7.1]
  def change
    add_column :vendors, :razorpay_key_id, :string, default: ""
    add_column :vendors, :razorpay_secret_id, :string, default: ""
  end
end
