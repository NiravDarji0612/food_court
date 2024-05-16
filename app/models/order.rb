class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :cart, optional: true
  belongs_to :vendor
  has_many :cart_items, dependent: :destroy

  enum :status, { not_approved: 0, approved: 1, cancle_order: 2, preparing_order: 3, ready_for_delivery: 4  }

  before_save :increment_token, on: :create

  def increment_token
    self.token_number = self.class&.last&.token_number.to_i + 1
  end
end
