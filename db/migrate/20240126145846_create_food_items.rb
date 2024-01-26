class CreateFoodItems < ActiveRecord::Migration[7.1]
  def change
    create_table :food_items do |t|
      t.string :name
      t.string :type
      t.string :sub_type, array: true, default: []
      t.string :taste, array: true, default: []
      t.string :tags, array: true, default: []
      t.integer :price

      t.timestamps
    end
  end
end
