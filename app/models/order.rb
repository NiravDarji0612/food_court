class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :cart, optional: true
  belongs_to :vendor

  enum :status, { pending: 0, preparing: 1, ready_for_delivery: 2 }
end
