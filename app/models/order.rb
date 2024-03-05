class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :cart
  has_many :food_items, dependent: :destroy
end
