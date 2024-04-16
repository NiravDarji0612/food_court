class AddSubTypeToCartItems < ActiveRecord::Migration[7.1]
  def change
    add_column :cart_items, :sub_type, :string
  end
end
