class AddOrderToCartItem < ActiveRecord::Migration[7.1]
  def change
    add_reference :cart_items, :order, foreign_key: true
  end
end
