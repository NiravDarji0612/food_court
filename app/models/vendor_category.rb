class VendorCategory < ApplicationRecord
  belongs_to :vendor
  belongs_to :category
  has_many :food_items, dependent: :destroy
end
