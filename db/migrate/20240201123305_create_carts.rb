class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.integer :final_price, default: 0
      t.references :customer, null: false, foreign_key: true
      t.timestamps
    end
  end
end
