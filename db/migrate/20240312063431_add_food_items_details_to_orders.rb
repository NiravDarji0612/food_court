class AddFoodItemsDetailsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :food_items_details, :jsonb, default: {}
  end
end
