class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :food_item
  belongs_to :order, optional: true
  before_save :update_cart

  private

  def update_cart
    cart.update(final_price: price_change.compact.sum) if price_changed?
  end
end
