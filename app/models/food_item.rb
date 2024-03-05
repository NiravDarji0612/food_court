class FoodItem < ApplicationRecord
  belongs_to :vendor_category
  belongs_to :cart, optional: true
end
