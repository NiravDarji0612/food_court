class Payment
  def initialize(vendor)
    @vendor = vendor
  end

  def razorpay_setup
    Razorpay.setup(@vendor.razorpay_key_id, @vendor.razorpay_secret_id)
  end
end
