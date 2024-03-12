class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :cart, null: false, foreign_key: true
      t.references :vendor, null: false, foreign_key: true
      t.integer :status, default: 0
      t.integer :amount_to_be_paid, default: 0
      t.string :preparing_time
      t.integer :total_items, default: 0
      t.string :token_number
      t.time :cancelled_at
      t.timestamps
    end
  end
end
