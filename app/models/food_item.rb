class FoodItem < ApplicationRecord
  has_many :vendor_food_items, dependent: :destroy
  has_many :vendors  
end
