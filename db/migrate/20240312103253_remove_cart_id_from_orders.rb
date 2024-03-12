class RemoveCartIdFromOrders < ActiveRecord::Migration[7.1]
  def change
    remove_column :orders, :cart_id
  end
end
